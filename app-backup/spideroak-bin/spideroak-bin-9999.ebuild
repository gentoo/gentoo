# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils unpacker

DESCRIPTION="Secure free online backup, storage, and sharing system"
HOMEPAGE="https://spideroak.com"

SRC_URI_BASE="https://spideroak.com/release/spideroak"
SRC_URI="x86? ( ${SRC_URI_BASE}/deb_x86 -> ${P}_x86.deb )
	amd64? ( ${SRC_URI_BASE}/deb_x64 -> ${P}_amd64.deb )"

RESTRICT="mirror strip"

LICENSE="spideroak"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus X"

DEPEND="dev-util/patchelf"
RDEPEND="
	app-crypt/mit-krb5[keyutils]
	media-libs/libpng:1.2
	dbus? ( sys-apps/dbus )
	X? (
		media-libs/fontconfig
		media-libs/freetype:2
		dev-libs/glib:2
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXmu
		x11-libs/libXrender
		x11-libs/libXt
	)
"

S=${WORKDIR}

QA_PREBUILT="*"

src_prepare() {
	# Set RPATH for preserve-libs handling (bug #400979).
	cd "${S}/opt/SpiderOakONE/lib" || die
	local x
	for x in `find` ; do
		# Use \x7fELF header to separate ELF executables and libraries
		[[ -f ${x} && $(od -t x1 -N 4 "${x}") == *"7f 45 4c 46"* ]] || continue
		patchelf --set-rpath '$ORIGIN' "${x}" || \
			die "patchelf failed on ${x}"
	done

	#Remove the libraries that break compatibility in modern systems
	#SpiderOak will use the system libs instead
	rm -f "${S}/opt/SpiderOakONE/lib/libstdc++.so.6"
	rm -f "${S}/opt/SpiderOakONE/lib/libgcc_s.so.1"
	rm -f "${S}/opt/SpiderOakONE/lib/libpng12.so.0"
	rm -f "${S}/opt/SpiderOakONE/lib/libz.so.1"

	eapply_user
}

src_install() {
	#install the wrapper script
	exeinto /usr/bin
	doexe usr/bin/SpiderOakONE

	# inotify_dir_watcher needs to be marked executable, bug #453266
	#chmod a+rx opt/SpiderOakONE/lib/inotify_dir_watcher

	#install the executable
	exeinto /opt/SpiderOakONE/lib
	doexe opt/SpiderOakONE/lib/SpiderOakONE
	doexe opt/SpiderOakONE/lib/inotify_dir_watcher
	rm -f opt/SpiderOakONE/lib/{SpiderOakONE,inotify_dir_watcher}

	#install the prebundled libraries
	insinto /opt/SpiderOakONE
	doins -r opt/SpiderOakONE/lib

	#install the config files
	use dbus || rm -rf etc/dbus-1
	insinto /
	doins -r etc

	#install the manpage
	doman usr/share/man/man1/SpiderOakONE.1.gz

	if use X; then
		domenu usr/share/applications/SpiderOakONE.desktop
		doicon usr/share/pixmaps/SpiderOakONE.png
	fi
}

pkg_postinst() {
	if ! use X; then
		einfo "For instructions on running SpiderOakONE without a GUI, please read the FAQ:"
		einfo "  https://spideroak.com/faq/questions/62/how_do_i_install_spideroak_on_a_headless_linux_server/"
		einfo "  https://spideroak.com/faq/questions/67/how_can_i_use_spideroak_from_the_commandline/"
	fi
}
