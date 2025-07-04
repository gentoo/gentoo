#!/usr/bin/env python3

import gi
import os
import re
import sys
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GdkPixbuf, Gdk, Pango

stage3_options = [
    "current-stage3-amd64-desktop-openrc",
    "current-stage3-amd64-desktop-systemd",
    "current-stage3-amd64-hardened-openrc",
    "current-stage3-amd64-hardened-selinux-openrc",
    "current-stage3-amd64-hardened-systemd",
    "current-stage3-amd64-llvm-openrc",
    "current-stage3-amd64-llvm-systemd",
    "current-stage3-amd64-musl-hardened",
    "current-stage3-amd64-musl-llvm",
    "current-stage3-amd64-musl",
    "current-stage3-amd64-nomultilib-openrc",
    "current-stage3-amd64-nomultilib-systemd",
    "current-stage3-amd64-openrc-splitusr",
    "current-stage3-amd64-openrc",
    "current-stage3-amd64-systemd",
    "current-stage3-x32-openrc",
    "current-stage3-x32-systemd",
]

CONFIG_FILE_PATH = "/etc/calamares.conf"
LOGO_PATH = "/etc/calamares/branding/gentoo_branding/gentoo.png"

class GentooInstaller(Gtk.Window):
    def __init__(self):
        super().__init__(title="Gentoo Linux Installer")
        self.set_default_size(800, 600)
        self.set_resizable(False)

        overlay = Gtk.Overlay()
        self.add(overlay)

        fixed = Gtk.Fixed()
        overlay.add(fixed)

        if os.path.exists(LOGO_PATH):
            pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_size(LOGO_PATH, 56, 56)
            logo = Gtk.Image.new_from_pixbuf(pixbuf)
            fixed.put(logo, 40, 32)
            self.set_icon_from_file(LOGO_PATH)

        frame = Gtk.Frame()
        frame.set_margin_top(80)
        frame.set_margin_bottom(40)
        frame.set_margin_start(100)
        frame.set_margin_end(60)
        overlay.add_overlay(frame)

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        box.set_margin_top(20)
        box.set_margin_bottom(20)
        box.set_margin_start(20)
        box.set_margin_end(20)
        frame.add(box)

        label = Gtk.Label(label="Which Gentoo Linux do you wish to install?")
        label.set_name("question_label")
        box.pack_start(label, False, False, 0)

        self.listbox = Gtk.ListBox()
        for option in stage3_options:
            row = Gtk.ListBoxRow()
            row_label = Gtk.Label(label=option, xalign=0)
            row.add(row_label)
            self.listbox.add(row)
        self.listbox.show_all()
        self.listbox.connect("row-activated", self.on_select)
        box.pack_start(self.listbox, True, True, 0)

        button_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        box.pack_start(button_box, False, False, 0)

        select_button = Gtk.Button(label="Select")
        select_button.connect("clicked", self.on_select)
        button_box.pack_start(select_button, True, True, 0)

        exit_button = Gtk.Button(label="Exit")
        exit_button.connect("clicked", lambda btn: self.get_application().quit())
        button_box.pack_start(exit_button, True, True, 0)

        css_provider = Gtk.CssProvider()
        css_provider.load_from_data(b"""
            #question_label {
                font-size: 20pt;
                font-weight: bold;
            }
        """)
        screen = Gdk.Screen.get_default()
        Gtk.StyleContext.add_provider_for_screen(
            screen,
            css_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        self.show_all()

    def on_select(self, widget, row=None):
        selected_row = self.listbox.get_selected_row()
        if selected_row:
            label = selected_row.get_child()
            selected_option = label.get_text()
            self.update_calamares_conf(selected_option)

    def update_calamares_conf(self, selected_option):
        try:
            if not os.path.exists(CONFIG_FILE_PATH):
                with open(CONFIG_FILE_PATH, "w") as file:
                    file.write("")

            with open(CONFIG_FILE_PATH, "r") as file:
                content = file.read()

            new_content = re.sub(r'^(?!\s*#).*stage3\s*=\s*".*?"', '', content, flags=re.MULTILINE)
            new_content = os.linesep.join([line for line in new_content.splitlines() if line.strip()])
            new_content += f"\nstage3 = \"{selected_option}\"\n"

            with open(CONFIG_FILE_PATH, "w") as file:
                file.write(new_content)

            dialog = Gtk.MessageDialog(parent=self, flags=0,
                message_type=Gtk.MessageType.INFO,
                buttons=Gtk.ButtonsType.OK,
                text=f"Stage3 updated to: {selected_option}")
            dialog.run()
            dialog.destroy()

        except Exception as e:
            dialog = Gtk.MessageDialog(parent=self, flags=0,
                message_type=Gtk.MessageType.ERROR,
                buttons=Gtk.ButtonsType.OK,
                text=f"Failed to update config: {e}")
            dialog.run()
            dialog.destroy()

def main():
    app = Gtk.Application()
    def on_activate(app):
        win = GentooInstaller()
        win.set_application(app)
    app.connect("activate", on_activate)
    app.run(sys.argv)

if __name__ == "__main__":
    main()