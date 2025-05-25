# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit autotools python-r1 toolchain-funcs

MY_PV="r$(ver_rs 1- -)"

DESCRIPTION="Redhat's Newt windowing toolkit development files"
HOMEPAGE="https://pagure.io/newt"
SRC_URI="https://github.com/mlichvar/newt/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gpm python nls tcl"
RESTRICT="test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/popt-1.6
	=sys-libs/slang-2*
	gpm? ( sys-libs/gpm )
	python? ( ${PYTHON_DEPS} )
	tcl? ( >=dev-lang/tcl-8.5:0 )
	"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${PN}-0.52.23-gold.patch
	"${FILESDIR}"/${PN}-0.52.24-c99-fix.patch
)

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	sed -i Makefile.in \
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
}

src_configure() {
	local versions=
	getversions() {
		versions+="${EPYTHON} "
	}
	use python && python_foreach_impl getversions

	econf \
		"$(use_with python '' "${versions}")" \
		$(use_with gpm gpm-support) \
		$(use_with tcl) \
		$(use_enable nls)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		install
	use python && python_foreach_impl python_optimize

	dodoc peanuts.py popcorn.py tutorial.sgml
	doman whiptail.1
	einstalldocs

	# don't want static archives
	rm "${ED}"/usr/$(get_libdir)/libnewt.a || die
}
