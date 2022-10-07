# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#version magic thanks to masterdriverz and UberLord using bash array instead of tr
trarr="0abcdefghi"
MY_PV="$(ver_cut 1)${trarr:$(ver_cut 2):1}$(ver_cut 3)"

DESCRIPTION="Portable Scheme library for all standard Scheme implementations"
HOMEPAGE="http://people.csail.mit.edu/jaffer/SLIB"
SRC_URI="http://groups.csail.mit.edu/mac/ftpdir/scm/${PN}-${MY_PV}.zip"
S="${WORKDIR}"/${PN}

LICENSE="public-domain BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="gambit scm"
RESTRICT="mirror"

RDEPEND="
	>=dev-scheme/guile-1.8.8:=
	gambit? ( dev-scheme/gambit )
	scm? ( dev-scheme/scm )
"
BDEPEND="
	${RDEPEND}
	>=sys-apps/texinfo-5.0
	app-arch/unzip
"

DOCS=( ANNOUNCE COPYING FAQ README ChangeLog slib.{txt,html} )

PATCHES=(
	"${FILESDIR}"/${P}-fix-makefile-guile.patch
	"${FILESDIR}"/${P}-fix-paths.patch
)

src_configure() {
	./configure --prefix=/usr --libdir=/usr/share || die
}

src_compile() {
	default

	makeinfo -o slib.txt --plaintext --force slib.texi || die
	makeinfo -o slib.html --html --no-split --force slib.texi || die
}

src_install() {
	# core
	insinto /usr/share/${PN}
	doins *.{dat,init,ps,scm}
	exeinto /usr/share/${PN}
	doexe *.sh

	# bin
	dodir /usr/bin/
	dosym -r /usr/share/${PN}/${PN}.sh /usr/bin/${PN}

	# env
	doenvd "${FILESDIR}"/50slib

	# guile
	for guile_version in 3.0 2.2 2.0 1.8 ; do
		if has_version "=dev-scheme/guile-${guile_version}*" ; then
			dodir /usr/share/guile/${guile_version}
			dosym -r /usr/share/${PN}/ /usr/share/guile/${guile_version}/${PN}
			break
		fi
	done

	# backwards compatibility
	dodir /usr/lib/
	dosym -r /usr/share/${PN}/ /usr/lib/${PN}

	# docs
	doinfo slib.info
	doman slib.1
	einstalldocs
}

_new_catalog() {
	if [[ ! "${1}" =~ ^(guile|scm)$ ]]; then
		echo -n "(load \"${ROOT}/usr/share/slib/${1}.init\")" || die
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
		mkdir -p "${ROOT}"/usr/share/gambc || die
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
