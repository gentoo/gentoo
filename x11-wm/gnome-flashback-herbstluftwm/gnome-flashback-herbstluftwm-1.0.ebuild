# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="GNOME Herbstluftwm session (via GNOME Flashback)"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
S="${WORKDIR}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="gnome-base/gnome-flashback"
RDEPEND="
	${DEPEND}
	>=x11-wm/herbstluftwm-0.9.6-r1
"

src_compile() {
	:
}

src_install() {
	insinto /usr/share/gnome-session/sessions
	# Keep this in sync with gnome-flashback
	# /usr/share/gnome-session/sessions/gnome-flashback-metacity.session
	newins - ${PN}.session <<-EOF
	[GNOME Session]
	Name=GNOME Flashback (herbstluftwm)
	EOF

	insinto /usr/share/xsessions
	newins - ${PN}.desktop <<-EOF
	[Desktop Entry]
	Name=GNOME Flashback (Herbstluftwm)
	Exec=gnome-session --session=${PN}
	EOF

	local user_unit_dir="$(systemd_get_userunitdir)"
	insinto "${user_unit_dir}"/gnome-session@${PN}.target.d
	newins - herbstluftwm.conf <<-EOF
	[Unit]
	Wants=herbstluftwm.service
	After=herbstluftwm.service
	EOF
	# Keep this in sync with
	# https://gitlab.gnome.org/GNOME/gnome-flashback/-/blob/master/data/systemd/gnome-flashback.session.conf.in
	# that is, what gnome-flashback installs as
	# /usr/lib/systemd/user/gnome-session@gnome-flashback-metacity.target.d/session.conf
	newins - session.conf <<-EOF
	[Unit]
	Wants=org.gnome.SettingsDaemon.A11ySettings.target
	Wants=org.gnome.SettingsDaemon.Color.target
	Wants=org.gnome.SettingsDaemon.Datetime.target
	Wants=org.gnome.SettingsDaemon.Housekeeping.target
	Wants=org.gnome.SettingsDaemon.Keyboard.target
	Wants=org.gnome.SettingsDaemon.MediaKeys.target
	Wants=org.gnome.SettingsDaemon.Power.target
	Wants=org.gnome.SettingsDaemon.PrintNotifications.target
	Wants=org.gnome.SettingsDaemon.Rfkill.target
	Wants=org.gnome.SettingsDaemon.ScreensaverProxy.target
	Wants=org.gnome.SettingsDaemon.Sharing.target
	Wants=org.gnome.SettingsDaemon.Smartcard.target
	Wants=org.gnome.SettingsDaemon.Sound.target
	Wants=org.gnome.SettingsDaemon.UsbProtection.target
	Wants=org.gnome.SettingsDaemon.Wwan.target
	Wants=org.gnome.SettingsDaemon.XSettings.target

	Wants=evolution-alarm-notify.service
	Wants=gcr-ssh-agent.socket
	Wants=gnome-disk-utility-notify.service
	Wants=gnome-software.service
	Wants=localsearch-3.service
	Wants=user-dirs-update-gtk.service

	Wants=gnome-flashback-clipboard.service
	Wants=gnome-flashback-idle-monitor.service
	Wants=gnome-flashback-media-keys.service
	Wants=gnome-flashback-polkit.service

	Requires=gnome-session-x11-services-ready.target
	Requires=gnome-flashback.target
	Wants=gnome-panel.service
	EOF
}
