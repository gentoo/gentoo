# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools java-pkg-opt-2

IUSE="bzip2 debug java lzo mecab ruby +zlib"

DESCRIPTION="a full-text search system for communities"
HOMEPAGE="http://fallabs.com/hyperestraier/"
SRC_URI="http://fallabs.com/hyperestraier/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
SLOT="0"

RDEPEND="dev-db/qdbm
	bzip2? ( app-arch/bzip2 )
	java? ( >=virtual/jre-1.4:* )
	lzo? ( dev-libs/lzo )
	mecab? ( app-text/mecab )
	ruby? ( dev-lang/ruby:= )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	java? ( >=virtual/jdk-1.4:* )"

PATCHES=(
	"${FILESDIR}"/${PN}-configure.patch
	"${FILESDIR}"/${PN}-ruby19.patch
)
HTML_DOCS=( doc/. )

AT_NOELIBTOOLIZE="yes"

he_foreach_api() {
	local u d
	for u in java ruby; do
		if ! use "${u}"; then
			continue
		fi
		for d in ${u}native ${u}pure; do
			einfo "${EBUILD_PHASE} ${d}"
			cd "${d}"
			case "${EBUILD_PHASE}" in
			prepare)
				mv configure.{in,ac}
				eautoreconf
				;;
			configure)
				econf
				;;
			compile)
				emake
				;;
			test)
				if [[ "${d}" == "${u}native" ]]; then
					emake check
				fi
				;;
			install)
				if [[ "${u}" != "java" ]]; then
					emake DESTDIR="${D}" install
				else
					java-pkg_dojar *.jar
					if [[ "${d}" == "${u}native" ]]; then
						dolib.so lib*.so*
					fi
				fi
				;;
			esac
			cd - >/dev/null
		done
	done
}

src_prepare() {
	default
	java-pkg-opt-2_src_prepare

	sed -i \
		-e "/^CFLAGS/s|$| ${CFLAGS}|" \
		-e "/^JAVACFLAGS/s|$| ${JAVACFLAGS}|" \
		-e '/^LDENV/d' \
		-e 's/make\( \|$\)/$(MAKE)\1/g' \
		Makefile.in {java,ruby}*/Makefile.in

	mv configure.{in,ac}
	eautoreconf
	he_foreach_api # prepare
}

src_configure() {
	econf \
		$(use_enable bzip2 bzip) \
		$(use_enable debug) \
		$(use_enable lzo) \
		$(use_enable mecab) \
		$(use_enable zlib)
	he_foreach_api
}

src_compile() {
	default
	he_foreach_api
}

src_test() {
	default
	he_foreach_api
}

src_install() {
	emake DESTDIR="${D}" MYDOCS= install
	einstalldocs
	he_foreach_api

	rm -f "${D}"/usr/bin/*test
}
