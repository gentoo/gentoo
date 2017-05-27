# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools flag-o-matic python-single-r1 versionator

DESCRIPTION="Provide access to (SM)BIOS information"
HOMEPAGE="http://linux.dell.com/files/libsmbios/"
SRC_URI="https://github.com/dell/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 OSL-2.0"
SLOT="0"
KEYWORDS="amd64 ~ia64 x86"
IUSE="doc graphviz nls python static-libs test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="dev-libs/libxml2
	sys-libs/zlib
	nls? ( virtual/libintl )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	graphviz? ( media-gfx/graphviz )
	nls? ( sys-devel/gettext )
	test? ( >=dev-util/cppunit-1.9.6 )"

PATCHES=(
	"${FILESDIR}/${PN}-fix-pie.patch"
	"${FILESDIR}/${PN}-2.2.28-cppunit-tests.patch"
	"${FILESDIR}/${PN}-2.3.0-doxygen_target.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# Don't build yum-plugin - we don't need it
	sed '/yum-plugin/d' -i Makefile.am || die

	# Fix version string in build system
	sed "/release_micro_version/s@\[1\]@[$(get_version_component_range 3)]@" \
		-i configure.ac || die

	eautoreconf
}

src_configure() {
	#Remove -O3 for bug #290097
	replace-flags -O3 -O2

	econf \
		$(use_enable doc doxygen) \
		$(use_enable graphviz) \
		$(use_enable nls) \
		$(use_enable python) \
		$(use_enable static-libs static)
}

src_install() {
	emake install DESTDIR="${D}"

	if use python ; then
		python_scriptinto /usr/sbin
		python_doscript "${ED%/}"/usr/sbin/smbios-{{keyboard,thermal,token,wakeup,wireless}-ctl,lcd-brightness,passwd,sys-info}
	fi

	insinto /usr/include/
	doins -r src/include/smbios/

	einstalldocs

	if ! use static-libs ; then
		find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
	fi
}
