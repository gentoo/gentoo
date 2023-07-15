# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit autotools python-r1 toolchain-funcs

MY_PV="r$(ver_rs 1- -)"

DESCRIPTION="Redhat's Newt windowing toolkit development files"
HOMEPAGE="https://pagure.io/newt"
SRC_URI="https://github.com/mlichvar/newt/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv sparc x86"
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
	"${FILESDIR}"/${PN}-0.52.23-gold.patch
	"${FILESDIR}"/${PN}-0.52.21-python-sitedir.patch
)

S=${WORKDIR}/${PN}-${MY_PV}

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
