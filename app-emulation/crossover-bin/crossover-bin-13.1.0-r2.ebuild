# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/crossover-bin/crossover-bin-13.1.0-r2.ebuild,v 1.3 2015/06/14 18:31:19 ulm Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit python-single-r1 unpacker

DESCRIPTION="Commercial version of app-emulation/wine with paid support."
HOMEPAGE="http://www.codeweavers.com/products/crossover/"
SRC_URI="install-crossover-${PV}.bin"

LICENSE="CROSSOVER-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+capi +cups doc +gphoto2 +gsm +jpeg +lcms +ldap +mp3 +nls +openal +opengl +png +scanner +ssl +v4l"
RESTRICT="fetch test"
QA_FLAGS_IGNORED="opt/cxoffice/.*"
QA_PRESTRIPPED="opt/cxoffice/lib/.*
	opt/cxoffice/bin/cxburner
	opt/cxoffice/bin/cxntlm_auth
	opt/cxoffice/bin/wineserver
	opt/cxoffice/bin/unrar
	opt/cxoffice/bin/wine-preloader
	opt/cxoffice/bin/cxdiag
	opt/cxoffice/bin/cxgettext
	opt/cxoffice/bin/wineloader
	"
S="${WORKDIR}"

DEPEND="dev-lang/perl
	app-arch/unzip
	${PYTHON_DEPS}"

RDEPEND="${DEPEND}
	!prefix? ( sys-libs/glibc )
	>=dev-python/pygtk-2.10[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-util/desktop-file-utils
	!app-emulation/crossover-office-pro-bin
	!app-emulation/crossover-office-bin
	capi? ( net-dialup/capi4k-utils )
	cups? ( net-print/cups[abi_x86_32(-)] )
	gsm? ( media-sound/gsm[abi_x86_32(-)] )
	jpeg? ( virtual/jpeg[abi_x86_32(-)] )
	lcms? ( media-libs/lcms:2 )
	ldap? ( net-nds/openldap[abi_x86_32(-)] )
	gphoto2? ( media-libs/libgphoto2[abi_x86_32(-)] )
	mp3? ( >=media-sound/mpg123-1.5.0[abi_x86_32(-)] )
	nls? ( sys-devel/gettext[abi_x86_32(-)] )
	openal? ( media-libs/openal[abi_x86_32(-)] )
	opengl? (
		virtual/glu[abi_x86_32(-)]
		virtual/opengl[abi_x86_32(-)]
	)
	png? ( media-libs/libpng:0[abi_x86_32(-)] )
	scanner? ( media-gfx/sane-backends[abi_x86_32(-)] )
	ssl? ( dev-libs/openssl:0[abi_x86_32(-)] )
	v4l? ( media-libs/libv4l[abi_x86_32(-)] )
	media-libs/alsa-lib[abi_x86_32(-)]
	>=media-libs/freetype-2.0.0[abi_x86_32(-)]
	media-libs/mesa[abi_x86_32(-)]
	sys-apps/util-linux[abi_x86_32(-)]
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
	x11-libs/libxcb[abi_x86_32(-)]"

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE}"
	einfo "and place ${A} in ${DISTDIR}"
}

src_unpack() {
	# self unpacking zip archive; unzip warns about the exe stuff
	unpack_zip ${A}
}

src_prepare() {
	python_fix_shebang .
	sed -e 's:/usr/local/etc/xdg /etc/xdg::' -i "${WORKDIR}/bin/locate_gui.sh" \
		 || die "Could not patch ${WORKDIR}/bin/locate_gui.sh"

	# Remove unnecessary files
	rm -r license.txt guis/ || die "Could not remove files"
	use doc || rm -r doc/ || die "Could not remove files"
}

src_install() {
	# Install crossover symlink, bug #476314
	dosym /opt/cxoffice/bin/crossover /opt/bin/crossover

	# Install documentation
	dodoc README changelog.txt
	rm README changelog.txt || die "Could not remove README and changelog.txt"

	# Install files
	dodir /opt/cxoffice
	cp -r ./* "${ED}opt/cxoffice" \
		|| die "Could not install into ${ED}opt/cxoffice"

	# Install configuration file
	insinto /opt/cxoffice/etc
	doins share/crossover/data/cxoffice.conf

	# Install requisite directories for menus
	dodir "/usr/share/applications"
	dodir "/etc/xdg/menus/applications-merged"

	# Install menus
	XDG_CONFIG_DIRS="${ED}etc/xdg" \
		XDG_DATA_DIRS="${ED}usr/share" \
		"${ED}opt/cxoffice/bin/cxmenu" --crossover --install \
		|| die "Could not install menus"

	# Fix menus
	sed -e "s:${ED}:/:" -i "${ED}usr/share/applications/"* \
		|| die "Could not fix menus"
}
