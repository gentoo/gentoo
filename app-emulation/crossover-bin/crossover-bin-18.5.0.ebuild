# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit python-single-r1 unpacker

DESCRIPTION="Commercial version of app-emulation/wine with paid support."
HOMEPAGE="https://www.codeweavers.com/products/"
SRC_URI="https://media.codeweavers.com/pub/crossover/cxlinux/demo/install-crossover-${PV}.bin"

LICENSE="CROSSOVER-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+capi +cups doc +gphoto2 +gsm +jpeg +lcms +ldap +mp3 +nls +openal +opencl +opengl +png +scanner +ssl +v4l"
REQUIRED_USE=${PYTHON_REQUIRED_USE}
RESTRICT="bindist test"

QA_FLAGS_IGNORED="opt/cxoffice/.*"
QA_PRESTRIPPED="
	opt/cxoffice/lib/.*
	opt/cxoffice/lib64/.*
	opt/cxoffice/bin/cxburner
	opt/cxoffice/bin/cxntlm_auth
	opt/cxoffice/bin/wineserver
	opt/cxoffice/bin/wineserver32
	opt/cxoffice/bin/wineserver64
	opt/cxoffice/bin/wine64-preloader
	opt/cxoffice/bin/unrar
	opt/cxoffice/bin/wine-preloader
	opt/cxoffice/bin/cxdiag
	opt/cxoffice/bin/cxdiag64
	opt/cxoffice/bin/cxgettext
	opt/cxoffice/bin/wineloader
	opt/cxoffice/bin/wineloader64
"

S="${WORKDIR}"

DEPEND=""
BDEPEND="${PYTHON_DEPS}
	dev-lang/perl
	app-arch/unzip
"

RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	!prefix? ( sys-libs/glibc )
	>=dev-python/pygtk-2.10:2[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-util/desktop-file-utils
	!app-emulation/crossover-office-pro-bin
	!app-emulation/crossover-office-bin
	capi? ( net-libs/libcapi[abi_x86_32(-)] )
	cups? ( net-print/cups[abi_x86_32(-)] )
	gsm? ( media-sound/gsm[abi_x86_32(-)] )
	jpeg? ( virtual/jpeg:0[abi_x86_32(-)] )
	lcms? ( media-libs/lcms:2 )
	ldap? ( net-nds/openldap[abi_x86_32(-)] )
	gphoto2? ( media-libs/libgphoto2[abi_x86_32(-)] )
	mp3? ( >=media-sound/mpg123-1.5.0[abi_x86_32(-)] )
	nls? ( sys-devel/gettext[abi_x86_32(-)] )
	openal? ( media-libs/openal[abi_x86_32(-)] )
	opencl? ( virtual/opencl[abi_x86_32(-)] )
	opengl? (
		virtual/glu[abi_x86_32(-)]
		virtual/opengl[abi_x86_32(-)]
	)
	png? ( media-libs/libpng:0[abi_x86_32(-)] )
	scanner? ( media-gfx/sane-backends[abi_x86_32(-)] )
	ssl? ( dev-libs/openssl:0[abi_x86_32(-)] )
	v4l? ( media-libs/libv4l[abi_x86_32(-)] )
	media-libs/alsa-lib[abi_x86_32(-)]
	media-libs/freetype:2[abi_x86_32(-)]
	media-libs/mesa[abi_x86_32(-)]
	sys-auth/nss-mdns[abi_x86_32(-)]
	sys-apps/util-linux[abi_x86_32(-)]
	sys-libs/ncurses-compat:5[abi_x86_32(-)]
	sys-libs/zlib[abi_x86_32(-)]
	x11-libs/libICE[abi_x86_32(-)]
	x11-libs/libSM[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXau[abi_x86_32(-)]
	x11-libs/libXdmcp[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libXi[abi_x86_32(-)]
	x11-libs/libXrandr[abi_x86_32(-)]
	x11-libs/libXxf86vm[abi_x86_32(-)]
	x11-libs/libxcb[abi_x86_32(-)]
"

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE}"
	einfo "and place ${A} into your DISTDIR directory"
}

src_unpack() {
	# self unpacking zip archive; unzip warns about the exe stuff
	unpack_zip ${A}
}

src_prepare() {
	default
	python_fix_shebang .

	sed -i \
		-e "s:xdg_install_icons(:&\"${ED}\".:" \
		-e "s:\"\(.*\)/applications:\"${ED}\1/applications:" \
		-e "s:\"\(.*\)/desktop-directories:\"${ED}\1/desktop-directories:" \
		"${S}/lib/perl/CXMenuXDG.pm"

	# Remove unnecessary files
	rm -r license.txt guis/ || die "Could not remove files"
	use doc || rm -r doc/ || die "Could not remove files"
}

src_install() {
	# Install crossover symlink, bug #476314
	dosym ../cxoffice/bin/crossover /opt/bin/crossover

	# Install documentation
	dodoc README changelog.txt
	rm README changelog.txt || die "Could not remove README and changelog.txt"

	# Install files
	dodir /opt/cxoffice
	#cp -r ./* "${ED}/opt/cxoffice" \
	find . | cpio -dumpl "${ED}/opt/cxoffice" 2>/dev/null \
		|| die "Could not install into ${ED}/opt/cxoffice"

	# Install configuration file
	insinto /opt/cxoffice/etc
	doins share/crossover/data/cxoffice.conf

	# Konqueror in its infinite wisdom decides to try opening things for
	# writing, which are sandbox violations. This breaks the install process if
	# it is installed, so we ninja edit it to false so it so doesn't run.
	sed -i -e 's/cxwhich konqueror/false &/' "${ED}/opt/cxoffice/bin/locate_gui.sh" \
		|| die "Could not apply workaround for konqueror"

	# Install menus
	# XXX: locate_gui.sh automatically detects *-application-merged directories
	# This means what we install will vary depending on the contents of
	# /etc/xdg, which is a QA violation. It is not clear how to resolve this.
	XDG_DATA_HOME="/usr/share" XDG_CONFIG_HOME="/etc/xdg" \
		"${ED}/opt/cxoffice/bin/cxmenu" --destdir="${ED}" --crossover --install \
		|| die "Could not install menus"

	# Revert ninja edit
	sed -i -e 's/false \(cxwhich konqueror\)/\1/' "${ED}/opt/cxoffice/bin/locate_gui.sh" \
		|| die "Could not apply workaround for konqueror"

	rm "${ED}/usr/share/applications/"*"Uninstall CrossOver Linux.desktop" \
		|| die "Could not remove uninstall menus"
	sed -i \
		-e "s:\"${ED}\".::" \
		-e "s:${ED}::" \
		"${ED}/opt/cxoffice/lib/perl/CXMenuXDG.pm" \
		|| die "Could not fix paths in ${ED}/opt/cxoffice/lib/perl/CXMenuXDG.pm"
	sed -i -e "s:${ED}:/:" \
		"${ED}/usr/share/applications/"*"CrossOver.desktop" \
		|| die "Could not fix paths of *.desktop files"
}

pkg_postinst() {
	einfo "${P} is open source software with the exception of the GUI."
	einfo "Source code can be obtained from:"
	einfo
	einfo "https://media.codeweavers.com/pub/crossover/source/crossover-sources-${PV}.tar.gz"
}
