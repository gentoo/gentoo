# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper xdg

# get the major version from PV
MY_PV=$(ver_cut 3)
MY_PN=${PN/-/_}

DESCRIPTION="Sophisticated text editor for code, markup and prose"
HOMEPAGE="https://www.sublimetext.com"
SRC_URI="
	amd64? ( https://download.sublimetext.com/sublime_text_build_${MY_PV}_x64.tar.xz )"
S="${WORKDIR}/${MY_PN}"

LICENSE="Sublime"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus"
RESTRICT="bindist mirror strip"

RDEPEND="
	dev-libs/glib:2
	sys-libs/glibc
	x11-libs/gtk+:3
	x11-libs/libX11
	dbus? ( sys-apps/dbus )"

PATCHES=(
	"${FILESDIR}"/${PN}-4_p4107-remove-deprecated-key-onlyshowin-from-launcher.patch
	"${FILESDIR}"/${PN}-4_p4107-set-explicit-startupwmclass-in-launcher.patch
)

QA_PREBUILT="*"

# Sublime bundles the kitchen sink, which includes python and other assorted
# modules. Do not try to unbundle these because you are guaranteed to fail.

src_install() {
	insinto /opt/${MY_PN}
	doins -r Packages Lib Icon # /Icon is used at runtime by the application
	doins changelog.txt libcrypto.so.1.1 libssl.so.1.1 libsqlite3.so sublime_text.desktop

	# sublime_merge looks for /opt/sublime_text/sublime_text
	exeinto /opt/${MY_PN}
	doexe crash_reporter plugin_host-3.3 plugin_host-3.8 sublime_text

	# sublime-text sets its WM_CLASS based on its argv[0]. A wrapper script is
	# used instead of a symlink to preserve a consistent WM_CLASS regardless of
	# how the application is launched. This causes the WM_CLASS to be
	# "sublime_text" which matches the .desktop entry.
	make_wrapper subl "/opt/${MY_PN}/sublime_text --fwdargv0 \"\$0\""
	domenu sublime_text.desktop

	local size
	for size in 16 32 48 128 256; do
		doicon --size ${size} Icon/${size}x${size}/${PN}.png
	done
}

pkg_postinst() {
	xdg_pkg_postinst

	elog 'Sublime Text 4'"'"'s window class changes from WM_CLASS="subl" to'
	elog 'WM_CLASS="sublime_text" matching other distributions.'
}
