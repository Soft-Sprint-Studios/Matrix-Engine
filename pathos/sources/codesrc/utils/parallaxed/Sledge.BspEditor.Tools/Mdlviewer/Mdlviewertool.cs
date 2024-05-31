using System.ComponentModel.Composition;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Threading.Tasks;
using Sledge.BspEditor.Commands;
using System.Windows.Forms;
using Sledge.BspEditor.Documents;
using Sledge.BspEditor.Modification;
using Sledge.BspEditor.Modification.Operations;
using Sledge.BspEditor.Tools.Properties;
using Sledge.Common.Shell.Commands;
using Sledge.Common.Shell.Components;
using Sledge.Common.Shell.Hotkeys;
using Sledge.Common.Shell.Menu;

namespace Sledge.BspEditor.Tools.ModelViewer
{
    [Export(typeof(ICommand))]
    [CommandID("Sledge.BspEditor:ModelViewer")]
    [MenuItem("Tools", "", "ModelViewer", "M")]
    [DefaultHotkey("Shift+M")]
    public class ModelViewerCommand : BaseCommand
    {
        public override string Name { get; set; } = "ModelViewer";

        public override string Details { get; set; } = "Open ModelViewer";

        protected override async Task Invoke(MapDocument document, CommandParameters parameters)
        {
            string currentDirectory = Directory.GetCurrentDirectory();
            string modelViewerPath = Path.Combine(currentDirectory, "ModelViewer.exe");

            if (File.Exists(modelViewerPath))
            {
                Process.Start(modelViewerPath);
            }
            else
            {
                MessageBox.Show("ModelViewer.exe not found!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}