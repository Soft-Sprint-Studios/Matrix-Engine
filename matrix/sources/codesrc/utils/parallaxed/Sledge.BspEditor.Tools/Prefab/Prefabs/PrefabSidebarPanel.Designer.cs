﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Sledge.BspEditor.Tools.Prefab {
    using System;
    
    
    /// <summary>
    ///   A strongly-typed resource class, for looking up localized strings, etc.
    /// </summary>
    // This class was auto-generated by the StronglyTypedResourceBuilder
    // class via a tool like ResGen or Visual Studio.
    // To add or remove a member, edit your .ResX file then rerun ResGen
    // with the /str option, or rebuild your VS project.
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "17.0.0.0")]
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    partial class PrefabSidebarPanel {
        
        private static global::System.Resources.ResourceManager resourceMan;
        
        private static global::System.Globalization.CultureInfo resourceCulture;
        
        [global::System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]

		private System.Windows.Forms.ComboBox FileContainer;
        private void InitializeComponent()
        {
			this.FileContainer = new System.Windows.Forms.ComboBox();
			this.PrefabList = new System.Windows.Forms.ComboBox();
			this.CreateButton = new System.Windows.Forms.Button();
			this.NewPrefab = new System.Windows.Forms.Button();
			this.NewPrefabName = new System.Windows.Forms.TextBox();
			this.NewLibName = new System.Windows.Forms.TextBox();
			this.CreateLib = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// FileContainer
			// 
			this.FileContainer.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.FileContainer.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.Append;
			this.FileContainer.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems;
			this.FileContainer.FormattingEnabled = true;
			this.FileContainer.Location = new System.Drawing.Point(4, 4);
			this.FileContainer.Name = "FileContainer";
			this.FileContainer.Size = new System.Drawing.Size(143, 21);
			this.FileContainer.TabIndex = 0;
			this.FileContainer.SelectedIndexChanged += new System.EventHandler(this.FileContainer_SelectedIndexChanged);
			this.FileContainer.SelectionChangeCommitted += new System.EventHandler(this.FileContainer_SelectionChangeCommitted);
			// 
			// PrefabList
			// 
			this.PrefabList.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.PrefabList.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.Append;
			this.PrefabList.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems;
			this.PrefabList.FormattingEnabled = true;
			this.PrefabList.Location = new System.Drawing.Point(4, 63);
			this.PrefabList.Name = "PrefabList";
			this.PrefabList.Size = new System.Drawing.Size(143, 21);
			this.PrefabList.TabIndex = 1;
			this.PrefabList.SelectedValueChanged += new System.EventHandler(this.PrefabList_SelectedValueChanged);
			// 
			// CreateButton
			// 
			this.CreateButton.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.CreateButton.Location = new System.Drawing.Point(4, 106);
			this.CreateButton.Name = "CreateButton";
			this.CreateButton.Size = new System.Drawing.Size(143, 23);
			this.CreateButton.TabIndex = 2;
			this.CreateButton.Text = "Create Prefab";
			this.CreateButton.UseVisualStyleBackColor = false;
			this.CreateButton.Click += new System.EventHandler(this.CreateButton_Click);
			// 
			// NewPrefab
			// 
			this.NewPrefab.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.NewPrefab.Location = new System.Drawing.Point(4, 170);
			this.NewPrefab.Name = "NewPrefab";
			this.NewPrefab.Size = new System.Drawing.Size(143, 23);
			this.NewPrefab.TabIndex = 3;
			this.NewPrefab.Text = "Save as new prefab";
			this.NewPrefab.UseVisualStyleBackColor = false;
			this.NewPrefab.Click += new System.EventHandler(this.NewPrefab_Click);
			// 
			// NewPrefabName
			// 
			this.NewPrefabName.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.NewPrefabName.Location = new System.Drawing.Point(4, 144);
			this.NewPrefabName.Name = "NewPrefabName";
			this.NewPrefabName.Size = new System.Drawing.Size(143, 20);
			this.NewPrefabName.TabIndex = 4;
			this.NewPrefabName.Text = "New prefab name";
			// 
			// NewLibName
			// 
			this.NewLibName.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.NewLibName.Location = new System.Drawing.Point(4, 200);
			this.NewLibName.Name = "NewLibName";
			this.NewLibName.Size = new System.Drawing.Size(143, 20);
			this.NewLibName.TabIndex = 5;
			this.NewLibName.Text = "New Library name";
			// 
			// CreateLib
			// 
			this.CreateLib.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.CreateLib.Location = new System.Drawing.Point(4, 227);
			this.CreateLib.Name = "CreateLib";
			this.CreateLib.Size = new System.Drawing.Size(143, 23);
			this.CreateLib.TabIndex = 6;
			this.CreateLib.Text = "Create library";
			this.CreateLib.UseVisualStyleBackColor = false;
			this.CreateLib.Click += new System.EventHandler(this.CreateLib_Click);
			// 
			// PrefabSidebarPanel
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.AutoSize = true;
			this.Controls.Add(this.CreateLib);
			this.Controls.Add(this.NewLibName);
			this.Controls.Add(this.NewPrefabName);
			this.Controls.Add(this.NewPrefab);
			this.Controls.Add(this.CreateButton);
			this.Controls.Add(this.PrefabList);
			this.Controls.Add(this.FileContainer);
			this.Name = "PrefabSidebarPanel";
			this.Size = new System.Drawing.Size(152, 388);
			this.ResumeLayout(false);
			this.PerformLayout();

        }

		private System.Windows.Forms.ComboBox PrefabList;
		private System.Windows.Forms.Button CreateButton;
		private System.Windows.Forms.Button NewPrefab;
		private System.Windows.Forms.TextBox NewPrefabName;
		private System.Windows.Forms.TextBox NewLibName;
		private System.Windows.Forms.Button CreateLib;

		/// <summary>
		///   Returns the cached ResourceManager instance used by this class.
		/// </summary>
		[global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Resources.ResourceManager ResourceManager {
            get {
                if (object.ReferenceEquals(resourceMan, null)) {
                    global::System.Resources.ResourceManager temp = new global::System.Resources.ResourceManager("Sledge.BspEditor.Editing.Components.Prefabs.PrefabSidebarPanel", typeof(PrefabSidebarPanel).Assembly);
                    resourceMan = temp;
                }
                return resourceMan;
            }
        }
        
        /// <summary>
        ///   Overrides the current thread's CurrentUICulture property for all
        ///   resource lookups using this strongly typed resource class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Globalization.CultureInfo Culture {
            get {
                return resourceCulture;
            }
            set {
                resourceCulture = value;
            }
        }
    }
}