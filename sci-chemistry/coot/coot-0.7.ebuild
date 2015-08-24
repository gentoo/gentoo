# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="2"

AUTOTOOLS_AUTORECONF="true"

inherit autotools-utils python toolchain-funcs versionator

MY_S2_PV=$(replace_version_separator 2 - ${PV})
MY_S2_P=${PN}-${MY_S2_PV/pre1/pre-1}
MY_S_P=${MY_S2_P}-${PR/r/revision-}
MY_PV=${PV}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Crystallographic Object-Oriented Toolkit for model building, completion and validation"
HOMEPAGE="http://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/"
SRC_URI="
	http://www.biop.ox.ac.uk/coot/software/source/releases/${MY_P}.tar.gz
	test? ( https://dev.gentoo.org/~jlec/distfiles/greg-data-${PV}.tar.gz  )"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="+openmp static-libs test"

AUTOTOOLS_IN_SOURCE_BUILD=1

SCIDEPS="
	>=sci-libs/ccp4-libs-6.1
	sci-libs/clipper
	>=sci-libs/coot-data-2
	>=sci-libs/gsl-1.3
	>=sci-libs/mmdb-1.23:0
	sci-libs/ssm
	<sci-libs/monomer-db-1
	sci-chemistry/reduce
	<sci-chemistry/refmac-5.6
	sci-chemistry/probe"

XDEPS="
	gnome-base/libgnomecanvas
	gnome-base/librsvg:2
	media-libs/libpng
	media-libs/freeglut
	x11-libs/gtk+:2
	x11-libs/goocanvas:0
	x11-libs/gtkglext"

SCHEMEDEPS="
	dev-scheme/net-http
	dev-scheme/guile-gui
	>=dev-scheme/guile-lib-0.1.6
	dev-scheme/guile-www
	>=x11-libs/guile-gtk-2.1"

RDEPEND="
	${SCIDEPS}
	${XDEPS}
	${SCHEMEDEPS}
	dev-python/pygtk:2
	>=dev-libs/gmp-4.2.2-r2
	>=net-misc/curl-7.19.6
	net-dns/libidn"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.4-r2
	dev-lang/swig
	sys-devel/bc
	test? ( dev-scheme/greg )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use openmp; then
		tc-has-openmp || die "Please use an OPENMP capable compiler"
	fi
	python_set_active_version 2
	python_pkg_setup
}

PATCHES=(
	"${FILESDIR}"/${P}-clipper-config.patch
	"${FILESDIR}"/${P}-goocanvas.patch
	"${FILESDIR}"/${P}-mmdb-config.patch
	"${FILESDIR}"/${P}-ssm.patch
	)

src_prepare() {
	sed \
		-e "s:AM_COOT_SYS_BUILD_TYPE:COOT_SYS_BUILD_TYPE=Gentoo-Linux-$(PYTHON)-gtk2 ; AC_MSG_RESULT([\$COOT_SYS_BUILD_TYPE]); AC_SUBST(COOT_SYS_BUILD_TYPE):g" \
		-i configure.in || die

	autotools-utils_src_prepare
}

src_configure() {
	# All the --with's are used to activate various parts.
	# Yes, this is broken behavior.
	local myeconfargs=(
		--includedir='${prefix}/include/coot'
		--with-goocanvas-prefix="${EPREFIX}/usr"
		--with-guile
		--with-python="${EPREFIX}/usr"
		--with-guile-gtk
		--with-gtk2
		--with-pygtk
		$(use_enable openmp)
		)
	autotools-utils_src_configure
}

src_test() {
	source "${EPREFIX}/etc/profile.d/40ccp4.setup.sh"
	mkdir "${T}"/coot_test

	export COOT_STANDARD_RESIDUES="${S}/standard-residues.pdb"
	export COOT_SCHEME_DIR="${S}/scheme/"
	export COOT_RESOURCES_FILE="${S}/cootrc"
	export COOT_PIXMAPS_DIR="${S}/pixmaps/"
	export COOT_DATA_DIR="${S}/"
	export COOT_PYTHON_DIR="${S}/python/"
	export PYTHONPATH="${COOT_PYTHON_DIR}:${PYTHONPATH}"
	export PYTHONHOME="${EPREFIX}"/usr/
	export CCP4_SCR="${T}"/coot_test/
	export CLIBD_MON="${EPREFIX}/usr/share/ccp4/data/monomers/"
	export SYMINFO="${S}/syminfo.lib"

	export COOT_TEST_DATA_DIR="${WORKDIR}"/data/greg-data

	cat > command-line-greg.scm <<- EOF
	(use-modules (ice-9 greg))
		(set! greg-tools (list "greg-tests"))
			(set! greg-debug #t)
			(set! greg-verbose 5)
			(let ((r (greg-test-run)))
				(if r
				(coot-real-exit 0)
				(coot-real-exit 1)))
	EOF

	einfo "Running test with following paths ..."
	einfo "COOT_STANDARD_RESIDUES $COOT_STANDARD_RESIDUES"
	einfo "COOT_SCHEME_DIR $COOT_SCHEME_DIR"
	einfo "COOT_RESOURCES_FILE $COOT_RESOURCES_FILE"
	einfo "COOT_PIXMAPS_DIR $COOT_PIXMAPS_DIR"
	einfo "COOT_DATA_DIR $COOT_DATA_DIR"
	einfo "COOT_PYTHON_DIR $COOT_PYTHON_DIR"
	einfo "PYTHONPATH $PYTHONPATH"
	einfo "PYTHONHOME $PYTHONHOME"
	einfo "CCP4_SCR ${CCP4_SCR}"
	einfo "CLIBD_MON ${CLIBD_MON}"
	einfo "SYMINFO ${SYMINFO}"

	"${S}"/src/coot-real --no-graphics --script command-line-greg.scm || die
	"${S}"/src/coot-real --no-graphics --script python-tests/coot_unittest.py || die
}
