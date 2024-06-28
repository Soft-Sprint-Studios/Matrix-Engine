namespace Sledge.Shell.Forms
{
    partial class ExceptionWindow
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            label1 = new System.Windows.Forms.Label();
            label4 = new System.Windows.Forms.Label();
            FrameworkVersion = new System.Windows.Forms.TextBox();
            label5 = new System.Windows.Forms.Label();
            OperatingSystem = new System.Windows.Forms.TextBox();
            label6 = new System.Windows.Forms.Label();
            SledgeVersion = new System.Windows.Forms.TextBox();
            label7 = new System.Windows.Forms.Label();
            FullError = new System.Windows.Forms.TextBox();
            CancelButton = new System.Windows.Forms.Button();
            label3 = new System.Windows.Forms.Label();
            applicationBranch = new System.Windows.Forms.TextBox();
            SuspendLayout();
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            label1.Location = new System.Drawing.Point(14, 10);
            label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            label1.Name = "label1";
            label1.Size = new System.Drawing.Size(411, 25);
            label1.TabIndex = 0;
            label1.Text = "Oops! Something went horribly wrong.";
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Location = new System.Drawing.Point(16, 208);
            label4.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            label4.Name = "label4";
            label4.Size = new System.Drawing.Size(72, 15);
            label4.TabIndex = 2;
            label4.Text = ".NET Version";
            // 
            // FrameworkVersion
            // 
            FrameworkVersion.Anchor = System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right;
            FrameworkVersion.Location = new System.Drawing.Point(215, 204);
            FrameworkVersion.Margin = new System.Windows.Forms.Padding(4, 3, 4, 3);
            FrameworkVersion.Name = "FrameworkVersion";
            FrameworkVersion.ReadOnly = true;
            FrameworkVersion.Size = new System.Drawing.Size(335, 23);
            FrameworkVersion.TabIndex = 3;
            // 
            // label5
            // 
            label5.AutoSize = true;
            label5.Location = new System.Drawing.Point(16, 238);
            label5.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            label5.Name = "label5";
            label5.Size = new System.Drawing.Size(101, 15);
            label5.TabIndex = 2;
            label5.Text = "Operating System";
            // 
            // OperatingSystem
            // 
            OperatingSystem.Anchor = System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right;
            OperatingSystem.Location = new System.Drawing.Point(215, 234);
            OperatingSystem.Margin = new System.Windows.Forms.Padding(4, 3, 4, 3);
            OperatingSystem.Name = "OperatingSystem";
            OperatingSystem.ReadOnly = true;
            OperatingSystem.Size = new System.Drawing.Size(335, 23);
            OperatingSystem.TabIndex = 3;
            // 
            // label6
            // 
            label6.AutoSize = true;
            label6.Location = new System.Drawing.Point(16, 272);
            label6.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            label6.Name = "label6";
            label6.Size = new System.Drawing.Size(83, 15);
            label6.TabIndex = 2;
            label6.Text = "ParallaxED Version";
            // 
            // SledgeVersion
            // 
            SledgeVersion.Anchor = System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right;
            SledgeVersion.Location = new System.Drawing.Point(215, 264);
            SledgeVersion.Margin = new System.Windows.Forms.Padding(4, 3, 4, 3);
            SledgeVersion.Name = "ParallaxEDVersion";
            SledgeVersion.ReadOnly = true;
            SledgeVersion.Size = new System.Drawing.Size(335, 23);
            SledgeVersion.TabIndex = 3;
            // 
            // label7
            // 
            label7.AutoSize = true;
            label7.Location = new System.Drawing.Point(16, 298);
            label7.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            label7.Name = "label7";
            label7.Size = new System.Drawing.Size(103, 15);
            label7.TabIndex = 2;
            label7.Text = "Full Error Message";
            // 
            // FullError
            // 
            FullError.Anchor = System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right;
            FullError.Location = new System.Drawing.Point(215, 294);
            FullError.Margin = new System.Windows.Forms.Padding(4, 3, 4, 3);
            FullError.Multiline = true;
            FullError.Name = "FullError";
            FullError.ReadOnly = true;
            FullError.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            FullError.Size = new System.Drawing.Size(335, 73);
            FullError.TabIndex = 3;
            // 
            // CancelButton
            // 
            CancelButton.Anchor = System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left;
            CancelButton.Location = new System.Drawing.Point(14, 477);
            CancelButton.Margin = new System.Windows.Forms.Padding(4, 3, 4, 3);
            CancelButton.Name = "CancelButton";
            CancelButton.Size = new System.Drawing.Size(141, 27);
            CancelButton.TabIndex = 4;
            CancelButton.Text = "Exit";
            CancelButton.UseVisualStyleBackColor = false;
            CancelButton.Click += CancelButtonClicked;
            // 
            // label3
            // 
            label3.Anchor = System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left;
            label3.AutoSize = true;
            label3.Location = new System.Drawing.Point(16, 375);
            label3.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            label3.Name = "label3";
            label3.Size = new System.Drawing.Size(108, 15);
            label3.TabIndex = 5;
            label3.Text = "Time of crash";
            // 
            // applicationBranch
            // 
            applicationBranch.Anchor = System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right;
            applicationBranch.Location = new System.Drawing.Point(214, 375);
            applicationBranch.Margin = new System.Windows.Forms.Padding(4, 3, 4, 3);
            applicationBranch.Name = "applicationBranch";
            applicationBranch.ReadOnly = true;
            applicationBranch.Size = new System.Drawing.Size(336, 23);
            applicationBranch.TabIndex = 6;
            // 
            // ExceptionWindow
            // 
            AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            ClientSize = new System.Drawing.Size(565, 517);
            Controls.Add(applicationBranch);
            Controls.Add(label3);
            Controls.Add(CancelButton);
            Controls.Add(FullError);
            Controls.Add(label7);
            Controls.Add(SledgeVersion);
            Controls.Add(label6);
            Controls.Add(OperatingSystem);
            Controls.Add(label5);
            Controls.Add(FrameworkVersion);
            Controls.Add(label4);
            Controls.Add(label1);
            Margin = new System.Windows.Forms.Padding(4, 3, 4, 3);
            MaximizeBox = false;
            MinimizeBox = false;
            MinimumSize = new System.Drawing.Size(581, 555);
            Name = "ExceptionWindow";
            StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            Text = "This isn't good!";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox FrameworkVersion;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox OperatingSystem;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox SledgeVersion;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox FullError;
        private System.Windows.Forms.Button CancelButton;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.TextBox applicationBranch;
	}
}