# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils toolchain-funcs python-single-r1

MYP=${PN}.net-${PV}

DESCRIPTION="Automated astrometric calibration programs and service"
HOMEPAGE="http://astrometry.net/"
SRC_URI="https://github.com/dstndstn/astrometry.net/releases/download/${PV}/${MYP}.tar.gz"

LICENSE="BSD GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	media-libs/libpng:0
	media-libs/netpbm
	sci-astronomy/wcslib:0=
	sci-libs/cfitsio:0=
	sci-libs/gsl:0=
	sys-libs/zlib:0=
	virtual/jpeg:0
	x11-libs/cairo
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-lang/swig:0
	virtual/pkgconfig"

S="${WORKDIR}/${MYP}"

PATCHES=(
	"${FILESDIR}"/${P}-soname.patch
	"${FILESDIR}"/${P}-dynlink.patch
	"${FILESDIR}"/${P}-qsortr.patch
)

src_prepare() {
	default
	# fix python scripts
	python_fix_shebang "${S}"
	sed -e "s|python setup-util.py|${EPYTHON} setup-util.py|" -i util/Makefile || die
	sed -e "s|python setup.py|${EPYTHON} setup.py|" -i {libkd,sdss,blind}/Makefile || die
	sed -e "s|python -c|${EPYTHON} -c|" -i blind/Makefile || die
	sed -e "s|python <<EOF|${EPYTHON} <<EOF|" -i util/simplexy.c || die
	sed -e "s|python -V|${EPYTHON} -V|" -i Makefile || die
	# respect use compilation flags
	sed -e '/-O3/d' -e '/-fomit-frame-pointer/d' -i util/makefile.common || die
	# as-needed
	sed -e "s|-lm|-lm $($(tc-getPKG_CONFIG) --libs wcslib gsl)|" -i util/Makefile || die
	export SYSTEM_GSL=yes
}

src_compile() {
	tc-export CC RANLIB AR
	# fragile makefiles, build targets sequentially
	emake
	emake py
	emake extra
	emake report.txt
}

src_test() {
	emake test
	local d
	for d in util blind libkd; do
		pushd ${d} > /dev/null
		./test || die "failed tests in ${d}"
		popd ${d} > /dev/null
	done
}

ap_make() {
	emake \
		INSTALL_DIR="${ED%/}/usr" \
		DATA_INSTALL_DIR="${ED%/}/usr/share/astrometry" \
		LIB_INSTALL_DIR="${ED%/}/usr/$(get_libdir)" \
		ETC_INSTALL_DIR="${ED%/}/etc" \
		MAN1_INSTALL_DIR="${ED%/}/usr/share/man/man1" \
		DOC_INSTALL_DIR="${ED%/}/usr/share/doc/${PF}" \
		EXAMPLE_INSTALL_DIR="${ED%/}/usr/share/doc/${PF}/examples" \
		PY_BASE_INSTALL_DIR="${ED%/}$(python_get_sitedir)/astrometry" \
		PY_BASE_LINK_DIR="../$(python_get_sitedir | sed -e 's|/usr/||')/astrometry" \
		FINAL_DIR="${EPREFIX%/}/usr" \
		DATA_FINAL_DIR="${EPREFIX%/}/usr/share/astrometry" \
		$@
}

src_install() {
	ap_make install-core
	ap_make -C util install
	ap_make -C blind install-extra

	# remove duplicates and non installable libraries
	rm "${ED}"/usr/bin/{fitscopy,imcopy,listhead} || die
	rm "${ED}"/usr/$(get_libdir)/lib*.a || die
	rm "${ED}"/usr/share/doc/${PF}/LICENSE || die

	use examples || rm -r "${ED}"/usr/share/doc/${PF}/examples
}
