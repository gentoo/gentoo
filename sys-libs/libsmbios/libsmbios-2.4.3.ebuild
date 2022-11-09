# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..11} )

inherit autotools flag-o-matic python-single-r1

DESCRIPTION="Provide access to (SM)BIOS information"
HOMEPAGE="https://github.com/dell/libsmbios"
SRC_URI="https://github.com/dell/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2+ OSL-2.1 ) BSD Boost-1.0"
SLOT="0"
KEYWORDS="-* amd64 ~ia64 x86"
IUSE="doc graphviz nls +python static-libs test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	test? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="!test? ( test )"

RDEPEND="dev-libs/libxml2
	sys-libs/zlib
	nls? ( virtual/libintl )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	graphviz? ( media-gfx/graphviz )
	nls? ( sys-devel/gettext )"
BDEPEND="test? (
	${PYTHON_DEPS}
	>=dev-util/cppunit-1.9.6
)"

PATCHES=(
	"${FILESDIR}/${PN}-2.2.28-cppunit-tests.patch"
	"${FILESDIR}/${PN}-2.4.3-avoid_bashisms.patch" #715202
	"${FILESDIR}/${PN}-2.4.3-insecure_rpaths.patch"
)

pkg_setup() {
	if use python || use test; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	default

	# Don't build yum-plugin - we don't need it
	sed '/yum-plugin/d' -i Makefile.am || die

	if use test; then
		python_fix_shebang src/pyunit/test*.py
	fi

	eautoreconf
}

src_configure() {
	#Remove -O3 for bug #290097
	replace-flags -O3 -O2

	local myeconfargs=(
		$(use_enable doc doxygen)
		$(use_enable graphviz)
		$(use_enable nls)
		$(use_enable python)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake install DESTDIR="${D}"

	if use python; then
		python_scriptinto /usr/sbin
		python_doscript "${ED}"/usr/sbin/smbios-{{battery,keyboard,thermal,token,wakeup,wireless}-ctl,lcd-brightness,passwd,sys-info}
	fi

	insinto /usr/include/
	doins -r src/include/smbios_c

	einstalldocs

	if ! use static-libs ; then
		find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
	fi
}
