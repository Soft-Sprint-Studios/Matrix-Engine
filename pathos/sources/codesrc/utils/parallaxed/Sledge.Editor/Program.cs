using System;
using System.Globalization;
using System.Threading;
using DiscordRPC.Logging;
using DiscordRPC;
using Sledge.Shell;

namespace Sledge.Editor
{
    static class Program
    {
        private static DiscordRpcClient client;

        public static void DiscordRPCRun()
        {
            client = new DiscordRpcClient("1247241451344101396");

            client.Logger = new ConsoleLogger() { Level = LogLevel.Warning };

            client.OnReady += (sender, e) =>
            {
                Console.WriteLine($"Received Ready from user {e.User.Username}");
            };

            client.OnPresenceUpdate += (sender, e) =>
            {
                Console.WriteLine($"Received Update! {e.Presence}");
            };

            client.Initialize();

            client.SetPresence(new RichPresence()
            {
                Details = "Parallax ED",
                State = "Editing Maps",
                Assets = new Assets()
                {
                }
            });
        }
        [STAThread]
        static void Main()
        {
            // From: https://stackoverflow.com/a/9160150
            // This is the easiest and most consistent way to force decimals to be used in winforms controls.
            // Users expect decimals to be displayed, since that's how VHE and other editors behave.
            // This is a deviation from expected behaviour of an application, which is why this is in
            // the editor bootstrapper, and not in the shell.

            DiscordRPCRun();

            var forceDecimalCulture = (CultureInfo)Thread.CurrentThread.CurrentCulture.Clone();

            forceDecimalCulture.NumberFormat.NumberDecimalSeparator = ".";
            forceDecimalCulture.NumberFormat.NumberGroupSeparator = ",";
            forceDecimalCulture.NumberFormat.NumberGroupSizes = new [] { 3 };
            forceDecimalCulture.NumberFormat.NumberNegativePattern = 1;

            Thread.CurrentThread.CurrentCulture = forceDecimalCulture;

            // We're finished ruining the culture, let's run the app now.
            Startup.Run();
        }
    }
}
