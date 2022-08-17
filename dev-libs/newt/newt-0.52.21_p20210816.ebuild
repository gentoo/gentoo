# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )

inherit autotools python-r1 toolchain-funcs

COMMIT=a7533580cd092e6a71c4ed722e830da4eb884d06

DESCRIPTION="Redhat's Newt windowing toolkit development files"
HOMEPAGE="https://pagure.io/newt"
SRC_URI="https://github.com/mlichvar/newt/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
IUSE="gpm nls tcl"
RESTRICT="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/popt-1.6
	=sys-libs/slang-2*
	gpm? ( sys-libs/gpm )
	tcl? ( >=dev-lang/tcl-8.5:0 )
	"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${PN}-0.52.13-gold.patch
	"${FILESDIR}"/${PN}-0.52.14-tcl.patch
	"${FILESDIR}"/${PN}-0.52.21-python-sitedir.patch
	"${FILESDIR}"/${P}-makefile-LDFLAGS-ordering.patch
	"${FILESDIR}"/${PN}-0.52.21-fix-non-POSIX-backticks.patch
)

S=${WORKDIR}/${PN}-${COMMIT}

src_prepare() {
	sed -i Makefile.in \
		-e 's|$(SHCFLAGS) -o|$(LDFLAGS) &|g' \
		-e 's|-g -o|$(CFLAGS) $(LDFLAGS) -o|g' \
		-e 's|-shared -o|$(CFLAGS) $(LDFLAGS) &|g' \
		-e 's|instroot|DESTDIR|g' \
		-e 's|	make |	$(MAKE) |g' \
		-e "s|	ar |	$(tc-getAR) |g" \
		|| die "sed Makefile.in"

	if [[ -n ${LINGUAS} ]]; then
		local lang langs
		for lang in ${LINGUAS}; do
			test -r po/${lang}.po && langs="${langs} ${lang}.po"
		done
		sed -i po/Makefile \
			-e "/^CATALOGS = /cCATALOGS = ${langs}" \
			|| die "sed po/Makefile"
	fi

	default
	eautoreconf

	# can't build out-of-source
	python_copy_sources
}

src_configure() {
	configuring() {
		econf \
			PYTHONVERS="${PYTHON}" \
			$(use_with gpm gpm-support) \
			$(use_with tcl) \
			$(use_enable nls)
	}
	python_foreach_impl run_in_build_dir configuring
}

src_compile() {
	building() {
		emake PYTHONVERS="${EPYTHON}"
	}
	python_foreach_impl run_in_build_dir building
}

src_install() {
	installit() {
		emake \
			DESTDIR="${D}" \
			PYTHON_SITEDIR="$(python_get_sitedir)" \
			PYTHONVERS="${EPYTHON}" \
			install
		python_optimize
	}
	python_foreach_impl run_in_build_dir installit
	dodoc peanuts.py popcorn.py tutorial.sgml
	doman whiptail.1
	einstalldocs

	# don't want static archives
	rm "${ED}"/usr/$(get_libdir)/libnewt.a || die
}
