using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Windows.Forms;

namespace Sledge.Shell.Forms
{
    public partial class ExceptionWindow : Form
    {
        public ExceptionInfo Info { get; set; }

        public ExceptionWindow(Exception ex)
        {
            InitializeComponent();

            var info = new ExceptionInfo(ex, "");
            Info = info;
            FrameworkVersion.Text = info.RuntimeVersion;
            OperatingSystem.Text = info.OperatingSystem;
            SledgeVersion.Text = info.ApplicationVersion;
            FullError.Text = info.FullStackTrace;
            applicationBranch.Text = info.ApplicationBranch;
        }

        private void CancelButtonClicked(object sender, EventArgs e)
        {
            Close();
        }


        public class ExceptionInfo
        {
            public Exception Exception { get; set; }
            public string RuntimeVersion { get; set; }
            public string OperatingSystem { get; set; }
            public string ApplicationVersion { get; set; }
            public DateTime Date { get; set; }
            public string InformationMessage { get; set; }
            public string UserEnteredInformation { get; set; }
            public string ApplicationBranch { get; set; }

            public string Source => Exception.Source;

            public string Message
            {
                get
                {
                    var msg = String.IsNullOrWhiteSpace(InformationMessage) ? Exception.Message : InformationMessage;
                    return msg.Split('\n').Select(x => x.Trim()).FirstOrDefault(x => !String.IsNullOrWhiteSpace(x));
                }
            }

            public string StackTrace => Exception.StackTrace;

            public string FullStackTrace { get; set; }

            public ExceptionInfo(Exception exception, string info)
            {
                Exception = exception;
                RuntimeVersion = System.Environment.Version.ToString();
                Date = DateTime.Now;
                InformationMessage = info;
                ApplicationVersion = FileVersionInfo.GetVersionInfo(typeof(ExceptionWindow).Assembly.Location).FileVersion;
                var buildInfo = GetBuildInfo();
                ApplicationBranch = $"{buildInfo.Tag} -- {buildInfo.BuildTime}";

                OperatingSystem = System.Environment.OSVersion.VersionString;

                var list = new List<Exception>();
                do
                {
                    list.Add(exception);
                    exception = exception.InnerException;
                } while (exception != null);

                FullStackTrace = (info + "\r\n").Trim();
                foreach (var ex in Enumerable.Reverse(list))
                {
                    FullStackTrace += "\r\n" + ex.Message + " (" + ex.GetType().FullName + ")\r\n" + ex.StackTrace;
                }
                FullStackTrace = FullStackTrace.Trim();
            }
            private BuildInfo GetBuildInfo()
            {
                var path = "./build";
                if (!File.Exists(path)) return new BuildInfo { BuildTime = DateTime.Now, Tag = "latest" };
                using (TextReader reader = new StreamReader(path))
                {
                    var buildTime = reader.ReadLine();
                    var tag = reader.ReadLine();
                    if (buildTime == null || tag == null) return new BuildInfo { BuildTime = DateTime.Now, Tag = "latest" };

                    return new BuildInfo
                    {
                        BuildTime = DateTime.ParseExact(buildTime, "yyyy-MM-dd HH:mm", null),
                        Tag = tag,
                    };
                }
            }
            private class BuildInfo
            {
                public string Tag { get; set; }
                public DateTime BuildTime { get; set; }
            }
        }
    }
}
