# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit check-reqs eutils xdg-utils

MY_PN="vscode"
MY_P="${MY_PN}"-"${PV}"

DESCRIPTION="Microsoft's free and open-source code editor"
HOMEPAGE="https://code.visualstudio.com/"
SRC_URI="https://github.com/Microsoft/${MY_PN}/archive/${PV}.tar.gz
	https://www.hlmjr.com/vscode-assets.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=net-libs/nodejs-8.11.1
	sys-apps/yarn"
RDEPEND="${DEPEND}
	dev-libs/nss
	dev-vcs/git
	gnome-base/gconf
	media-libs/alsa-lib
	x11-libs/gtk+:2
	x11-libs/libnotify
	x11-libs/libxkbfile
	x11-libs/libXScrnSaver
	x11-libs/libXtst"

S="${WORKDIR}"/"${MY_P}"

CHECKREQS_MEMORY="2G" # due to max_old_space_size node setting in src_compile

QA_PREBUILT="/opt/${PN}/libffmpeg.so /opt/${PN}/libnode.so"

pkg_pretend() {
	check-reqs_pkg_pretend
}

pkg_setup() {
	check-reqs_pkg_setup
	ulimit -n 5120 || die # avoid git errors >=1.22.0
}

src_compile() {
	# MS writes to different output directory based on arch w/different naming scheme
	if use amd64; then
		OUTPUT_ARCH=x64
	elif use x86; then
		OUTPUT_ARCH=ia32
	fi

	yarn install --arch=${OUTPUT_ARCH} || die

	# adjust max_old_space_size because default may be too low for node to build
	/usr/bin/node --max_old_space_size=2048 node_modules/gulp/bin/gulp.js vscode-linux-${OUTPUT_ARCH} || die
}

src_install() {
	dosym "bin/code-oss" "/usr/bin/code-oss"
	domenu "${FILESDIR}/vscode.desktop"
	doicon "${WORKDIR}/vscode.png"
	pushd "${WORKDIR}"/VSCode-linux-"${OUTPUT_ARCH}" > /dev/null || die
	insinto "/opt/${PN}"
	doins -r {locales,resources}
	doins *.{bin,dat,pak,so}
	exeinto "/opt/${PN}"
	doexe code-oss
	exeinto "/opt/${PN}/bin"
	doexe bin/code-oss
	popd > /dev/null || die
}

pkg_postinst() {
	xdg_desktop_database_update

	elog "If you see the following error when loading a large workspace in VSCode:"
	elog "    \"Code - OSS is running out of file handles.\""
	elog "Raise the value of fs.inotify.max_user_watches in /etc/sysctl.conf and run:"
	elog "    sysctl -p"
	elog "https://code.visualstudio.com/docs/setup/linux#_error-enospc"
}

pkg_postrm() {
	xdg_desktop_database_update
}

# TODO: Fix QA warnings (strip)
