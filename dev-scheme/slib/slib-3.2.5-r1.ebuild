# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit versionator

#version magic thanks to masterdriverz and UberLord using bash array instead of tr
trarr="0abcdefghi"
MY_PV="$(get_version_component_range 1)${trarr:$(get_version_component_range 2):1}$(get_version_component_range 3)"

DESCRIPTION="Portable Scheme library for all standard Scheme implementations"
HOMEPAGE="http://people.csail.mit.edu/jaffer/SLIB"
SRC_URI="http://swiss.csail.mit.edu/ftpdir/scm/${PN}-${MY_PV}.tar.gz"

RESTRICT="mirror"

LICENSE="public-domain BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="gambit scm"

RDEPEND="
	>=sys-apps/texinfo-5.0
	>=dev-scheme/guile-1.8.8:=
	gambit? ( dev-scheme/gambit )
	scm? ( dev-scheme/scm )"
DEPEND="${RDEPEND}"

DOCS=( ANNOUNCE COPYING FAQ README ChangeLog slib.{txt,html} )

PATCHES=(
	"${FILESDIR}/${P}-fix-paths.patch"
	"${FILESDIR}/${P}-fix-makefile-guile.patch"
)

S=${WORKDIR}/${PN}-${MY_PV}

src_configure() {
	./configure \
		--prefix=/usr \
		--libdir=/usr/share || die
}

src_compile() {
	default

	makeinfo -o slib.txt --plaintext --force slib.texi || die
	makeinfo -o slib.html --html --no-split --force slib.texi || die
}

src_install() {
	# core
	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	doins *.{dat,init,ps,scm,sh}

	# permissions
	local i
	for i in "${ED%/}"/usr/share/${PN}/*.sh ; do
		fperms +x /usr/share/${PN}/$(basename "$i")
	done

	# bin
	dodir /usr/bin/
	dosym /usr/share/${PN}/${PN}.sh /usr/bin/${PN}

	# env
	doenvd "${FILESDIR}/50slib"

	# docs
	doinfo slib.info
	doman slib.1

	# guile
	if has_version '=dev-scheme/guile-2.0*'; then
		dodir /usr/share/guile/2.0
		dosym /usr/share/${PN}/ /usr/share/guile/2.0/${PN}
	else
		dodir /usr/share/guile/1.8
		dosym /usr/share/${PN}/ /usr/share/guile/1.8/${PN}
	fi

	# backwards compatibility
	dodir /usr/lib/
	dosym /usr/share/${PN}/ /usr/lib/${PN}
}

_new_catalog() {
	if [[ ! "$1" =~ ^(guile|scm)$ ]]; then
		echo -n "(load \"${ROOT}/usr/share/slib/$1.init\")" || die
	fi
	echo " (require 'new-catalog) (slib:report-version)" || die
}

pkg_postinst() {
	local SCHEME_LIBRARY_PATH=/usr/share/slib/

	# catalogs
	einfo "Updating implementation catalogs.."
	guile -c "(use-modules (ice-9 slib)) $(_new_catalog guile)" |& grep -i '^slib' || die

	# broken as for now
	#	if use elk ; then
	#		echo "$(_new_catalog elk)" | elk -l -
	#	fi

	if use gambit ; then
		gsi -e "$(_new_catalog gambit)" || die
	fi

	if use scm ; then
		scm -e "$(_new_catalog scm)" || die
	fi
}

pkg_postrm() {
	for impl in 'guile/*' gambc scm; do
		rm -f "${ROOT}/usr/"lib*/${impl}/slibcat \
			"${ROOT}/usr/share/"${impl}/slibcat || die
	done
}
