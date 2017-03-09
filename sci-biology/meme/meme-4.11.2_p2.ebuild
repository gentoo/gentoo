# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools perl-functions python-single-r1 versionator

MY_PV=$(get_version_component_range 1-3)
MY_P=${PN}_${MY_PV}

DESCRIPTION="The MEME/MAST system - Motif discovery and search"
HOMEPAGE="http://meme-suite.org/tools/meme"
SRC_URI="http://meme-suite.org/meme-software/${MY_PV}/${MY_P}.tar.gz"

LICENSE="meme"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples mpi"

RDEPEND="
	${PYTHON_DEPS}
	app-shells/tcsh
	dev-libs/libxml2:2
	dev-libs/libxslt
	sys-libs/zlib
	app-text/ghostscript-gpl
	media-gfx/imagemagick
	dev-lang/perl:=
	dev-perl/HTML-Parser
	dev-perl/HTML-Template
	dev-perl/Log-Log4perl
	dev-perl/Math-CDF
	dev-perl/XML-Compile-SOAP
	dev-perl/XML-Compile-WSDL11
	dev-perl/XML-Parser
	dev-perl/XML-Simple
	virtual/perl-Data-Dumper
	virtual/perl-Exporter
	virtual/perl-File-Path
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-Getopt-Long
	virtual/perl-Scalar-List-Utils
	virtual/perl-Time-HiRes
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${MY_P}"
PATCHES=(
	"${FILESDIR}"/${PN}-4.11.2_p2-patch1.patch
	"${FILESDIR}"/${PN}-4.11.2_p2-patch2.patch
	"${FILESDIR}"/${PN}-4.11.2_p2-fix-build-system.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
	perl_set_version
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir="${EPREFIX}"/etc/${PN} \
		--with-logs="${EPREFIX}"/var/log/${PN} \
		--with-perl=perl \
		--with-convert=convert \
		--with-gs=gs \
		--disable-build-libxml2 \
		--disable-build-libxslt \
		$(use_enable debug) \
		$(use_enable doc) \
		$(use_enable examples) \
		$(use_enable !mpi serial) \
		--with-perl-dir="${VENDOR_LIB#${EPREFIX}/usr}" \
		PYTHON="${EPYTHON}"

	# delete bundled libs, just to be sure. These need
	# to be removed after econf, else AC_OUTPUT will fail
	rm -r src/{libxml2,lib{,e}xslt} || die
}

src_test() {
	# bug #297070
	emake -j1 test
}

src_install() {
	default
	docompress -x /usr/share/doc/${PF}/examples

	# prefix all binaries with 'meme-', in order
	# to prevent collisions, bug 455010
	cd "${ED%/}"/usr/bin/ || die
	local i
	for i in *; do
		if [[ $i != meme-* ]]; then
			mv {,meme-}"${i}" || die
		fi
	done

	keepdir /var/log/meme
}
