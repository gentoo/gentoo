# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit guile

#version magic thanks to masterdriverz and UberLord using bash array instead of tr
trarr="0abcdefghi"
MY_PV="$(ver_cut 1)${trarr:$(ver_cut 2):1}$(ver_cut 3)"

DESCRIPTION="Portable Scheme library for all standard Scheme implementations"
HOMEPAGE="http://people.csail.mit.edu/jaffer/SLIB"
SRC_URI="http://groups.csail.mit.edu/mac/ftpdir/scm/${PN}-${MY_PV}.zip"
S="${WORKDIR}"/${PN}

LICENSE="public-domain BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="gambit scm"
RESTRICT="mirror"
REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="
	${GUILE_DEPS}
	gambit? ( dev-scheme/gambit )
	scm? ( dev-scheme/scm )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/texinfo
	app-arch/unzip
"

DOCS=( ANNOUNCE COPYING FAQ README ChangeLog slib.{txt,html} )

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.5-fix-paths.patch
)

src_configure() {
	./configure \
		--prefix=/usr \
		--libdir=/usr/share \
		|| die
}

src_compile() {
	default

	makeinfo -o slib.txt --plaintext --force slib.texi || die
	makeinfo -o slib.html --html --no-split --force slib.texi || die
}

_new_catalog() {
	if [[ ${1} != @(guile|scm) ]] ; then
		echo -n "(load \"${ROOT}/usr/share/slib/${1}.init\")" || die
	fi
	echo " (require 'new-catalog) (slib:report-version)" || die
}

guile_generate_catalog() {
	# FIXME(arsen): we need to also compile the .go files..
	local gpath="${ED}/$(${GUILE} -c '(display (%library-dir))')"
	local -x GUILE_IMPLEMENTATION_PATH="${gpath}"
	assert "Could not determine the library directory"
	mkdir -p "${gpath}" || die
	ln -sr "${ED}/usr/share/slib" "${GUILE_IMPLEMENTATION_PATH}/slib" \
		|| die
	"${GUILE}" --no-auto-compile \
			   -L "${gpath}" \
			   -c "
		(use-modules (ice-9 slib))
		(require 'new-catalog)
	"
	assert "Failed to generate catalogs for Guile"
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

	# backwards compatibility
	dodir /usr/lib/
	dosym -r /usr/share/${PN}/ /usr/lib/${PN}

	# docs
	doinfo slib.info
	doman slib.1
	einstalldocs

	local -x SCHEME_LIBRARY_PATH="${ED}"/usr/share/slib/

	# catalogs
	einfo "Updating implementation catalogs.."
	guile_foreach_impl guile_generate_catalog

	# broken as for now
	#	if use elk ; then
	#		echo "$(_new_catalog elk)" | elk -l -
	#	fi

	if use gambit ; then
		local -x GAMBIT_IMPLEMENTATION_PATH="${ED}"/usr/share/gambc/
		mkdir -p "${ED}"/usr/share/gambc || die
		gsi -e "$(_new_catalog gambit)" || die
	fi

	if use scm ; then
		scm -e "$(_new_catalog scm)" || die
	fi
}
