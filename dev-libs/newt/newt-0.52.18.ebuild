# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit python-r1 eutils multilib autotools toolchain-funcs

DESCRIPTION="Redhat's Newt windowing toolkit development files"
HOMEPAGE="https://pagure.io/newt"
SRC_URI="https://releases.pagure.org/newt/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="gpm tcl nls"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/popt-1.6
	=sys-libs/slang-2*
	elibc_uclibc? ( sys-libs/ncurses )
	gpm? ( sys-libs/gpm )
	tcl? ( >=dev-lang/tcl-8.5:0 )
	"
DEPEND="${RDEPEND}"

src_prepare() {
	# bug 73850
	if use elibc_uclibc; then
		sed -i -e 's:-lslang:-lslang -lncurses:g' Makefile.in || die
	fi

	sed -i Makefile.in \
		-e 's|$(SHCFLAGS) -o|$(LDFLAGS) &|g' \
		-e 's|-g -o|$(CFLAGS) $(LDFLAGS) -o|g' \
		-e 's|-shared -o|$(CFLAGS) $(LDFLAGS) &|g' \
		-e 's|instroot|DESTDIR|g' \
		-e 's|	make |	$(MAKE) |g' \
		-e "s|	ar |	$(tc-getAR) |g" \
		|| die "sed Makefile.in"

	local langs=""
	if [ -n "${LINGUAS}" ]; then
		for lang in ${LINGUAS}; do
			test -r po/${lang}.po && langs="${langs} ${lang}.po"
		done
		sed -i po/Makefile \
			-e "/^CATALOGS = /cCATALOGS = ${langs}" \
			|| die "sed po/Makefile"
	fi

	epatch "${FILESDIR}"/${PN}-0.52.13-gold.patch \
		"${FILESDIR}"/${PN}-0.52.14-tcl.patch \
		"${FILESDIR}"/${PN}-0.52.15-makefile.patch
	eautoreconf
}

src_configure() {
	econf \
		PYTHONVERS="${PYTHON}" \
		$(use_with gpm gpm-support) \
		$(use_with tcl) \
		$(use_enable nls)
}

src_compile() {
	building() {
		emake PYTHONVERS="${EPYTHON}"
	}
	python_foreach_impl building
}

src_install() {
	installit() {
		emake \
			DESTDIR="${D}" \
			PYTHONVERS="${EPYTHON}" \
			install
		python_optimize
	}
	python_foreach_impl installit
	dodoc peanuts.py popcorn.py tutorial.sgml
	doman whiptail.1
}
