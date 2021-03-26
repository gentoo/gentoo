# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools epatch versionator

DESCRIPTION="C-Client Library for Open Source Java Message Service (JMS)"
HOMEPAGE="https://mq.java.net/"

# set this for rc and final versions to the build-number of open-mq
MY_BUILDV="b7"

LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

if [[ $(x=( $(get_all_version_components) ); echo ${x[3]}) == '.' ]]; then
	MY_PV=$(replace_version_separator 2 'u' $(get_version_component_range 1-3))
else
	MY_PV=$(get_version_component_range 1-2)
fi

if [[ ${PV} == *rc* || ${PV} == *beta* ]]; then
	for x in $(get_version_components); do
		if [[ ${x} == rc* ]]; then
			MY_BUILDV="${MY_BUILDV}-${x}"
			break
		fi
		if [[ ${x} == beta* ]]; then
			MY_BUILDV=b${x#beta}
			break
		fi
	done
else
	MY_BUILDV="${MY_BUILDV}-final"
fi

MY_ZIPV=$(replace_version_separator 1 _ $(get_version_component_range 1-2))
SRC_URI="http://download.java.net/mq/open-mq/${MY_PV}/${MY_BUILDV}/openmq${MY_ZIPV}-source.zip -> openmq${MY_PV}${MY_BUILDV}-source.zip"

RDEPEND="
	dev-libs/nss
	dev-libs/nspr
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-arch/unzip
"

S="${WORKDIR}/mq/src/share/cclient"

src_prepare() {
	epatch "${FILESDIR}"/${P}-aix-gcc.patch

	einfo "avoiding potential conflict with <xa.h>"
	mkdir cshim/mq || die
	mv cshim/xa.h cshim/mq/ || die
	ln -s mq/xa.h cshim/xa.h || die
	sed -i -e 's,"xa.h","mq/xa.h",' cshim/mqxaswitch.h || die
	eend $?

	cp "${FILESDIR}"/Makefile.in-4 Makefile.in || die
	cat > configure.ac <<-EOF
		AC_INIT(local-libtool, 0)
		AC_PROG_CC
		AC_PROG_CXX
		AC_PROG_LIBTOOL
		AC_OUTPUT(Makefile)
	EOF

	# bug #778329
	sed -e 's/--no-undefined/-no-undefined/' \
		-e "s/'\*Test\*' ')')/'\*Test\*' ')' | grep -v examples)/" \
		-i "${S}"/Makefile.in || die

	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	dodoc -r "${WORKDIR}"/mq/src/doc/en/.
	find "${ED}" -name '*.la' -delete || die
}
