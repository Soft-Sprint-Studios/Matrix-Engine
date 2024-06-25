using System;

namespace Sledge.Shell.Settings.Editors
{
    partial class ColorEditor
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.TrackBar AlphaTrackBar;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            this.ColorPanel = new System.Windows.Forms.Panel();
            this.Label = new System.Windows.Forms.Label();
            this.HexBox = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.AlphaTrackBar = new System.Windows.Forms.TrackBar();
            this.SuspendLayout();

            // ColorPanel
            this.ColorPanel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.ColorPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.ColorPanel.Location = new System.Drawing.Point(224, 3);
            this.ColorPanel.Name = "ColorPanel";
            this.ColorPanel.Size = new System.Drawing.Size(53, 20);
            this.ColorPanel.TabIndex = 3;
            this.ColorPanel.Click += new System.EventHandler(this.PickColor);

            // Label
            this.Label.AutoSize = true;
            this.Label.Location = new System.Drawing.Point(3, 6);
            this.Label.Name = "Label";
            this.Label.Size = new System.Drawing.Size(35, 13);
            this.Label.TabIndex = 2;
            this.Label.Text = "label1";

            // HexBox
            this.HexBox.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.HexBox.Location = new System.Drawing.Point(296, 3);
            this.HexBox.Name = "HexBox";
            this.HexBox.Size = new System.Drawing.Size(51, 20);
            this.HexBox.TabIndex = 4;
            this.HexBox.Text = "FFFFFF";
            this.HexBox.TextChanged += new System.EventHandler(this.UpdateHex);
            this.HexBox.Leave += new System.EventHandler(this.HexUnfocused);

            // label1
            this.label1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(281, 6);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(14, 13);
            this.label1.TabIndex = 5;
            this.label1.Text = "#";

            // AlphaTrackBar
            this.AlphaTrackBar.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.AlphaTrackBar.Location = new System.Drawing.Point(353, 3);
            this.AlphaTrackBar.Minimum = 0;
            this.AlphaTrackBar.Maximum = 1000;
            this.AlphaTrackBar.Name = "AlphaTrackBar";
            this.AlphaTrackBar.Size = new System.Drawing.Size(104, 45);
            this.AlphaTrackBar.TabIndex = 6;
            this.AlphaTrackBar.ValueChanged += new System.EventHandler(this.AlphaTrackBar_ValueChanged);

            // ColorEditor
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.label1);
            this.Controls.Add(this.HexBox);
            this.Controls.Add(this.ColorPanel);
            this.Controls.Add(this.Label);
            this.Controls.Add(this.AlphaTrackBar);
            this.Name = "ColorEditor";
            this.Size = new System.Drawing.Size(460, 26);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        private void AlphaTrackBar_ValueChanged(object sender, EventArgs e)
        {
        }

        private System.Windows.Forms.Panel ColorPanel;
        private System.Windows.Forms.Label Label;
        private System.Windows.Forms.TextBox HexBox;
        private System.Windows.Forms.Label label1;
    }
}
