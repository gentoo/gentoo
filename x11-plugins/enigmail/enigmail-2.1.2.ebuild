# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit python-any-r1

DESCRIPTION="Mozilla extension to provide GPG support in mail clients"
HOMEPAGE="https://www.enigmail.net/"

SLOT="0"
LICENSE="MPL-2.0 GPL-3"
IUSE=""
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.code.sf.net/p/enigmail/source"
	S="${WORKDIR}/${P}"
else
	if [[ ${PV} = *_beta* ]] ; then
		SRC_URI="https://www.enigmail.net/download/beta/${P/_/-}.tar.gz"
	else
		SRC_URI="https://www.enigmail.net/download/source/${P}.tar.gz"
		KEYWORDS="~alpha amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
	fi
	S="${WORKDIR}/${PN}"
fi

RDEPEND="
	( >=app-crypt/gnupg-2.0
		|| (
			app-crypt/pinentry[gtk(-)]
			app-crypt/pinentry[qt5(-)]
		)
	)
	!<mail-client/thunderbird-52.5.0
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	app-arch/zip
	dev-lang/perl
	"

PATCHES=( "${FILESDIR}"/enigmail-no_pEp_auto_download.patch )

src_compile() {
	# Required or parallel make fails
	emake -C stdlib createlib

	emake ipc public ui package lang stdlib
	emake xpi

}

src_install() {
	local emid=$(sed -n '/"id":/!d; s/.*\({.*}\).*/\1/; p; q' build/dist/manifest.json)
	[[ -n ${emid} ]] || die "Could not scrape EM:ID from install.rdf"

	mv build/enigmail*.xpi build/"${emid}.xpi" || die 'Could not rename XPI to match EM:ID'

	# thunderbird
	insinto "/usr/share/mozilla/extensions/{3550f703-e582-4d05-9a08-453d09bdfdc6}"
	doins build/"${emid}.xpi"

	# seamonkey
	insinto "/usr/share/mozilla/extensions/{92650c4d-4b8e-4d2a-b7eb-24ecf4f6b63a}"
	doins build/"${emid}.xpi"
}

pkg_postinst() {
	local peimpl=$(eselect --brief --colour=no pinentry show)
	case "${peimpl}" in
	*gtk*|*qt*) ;;
	*)	ewarn "The pinentry front-end currently selected is not one supported by thunderbird."
		ewarn "You may be prompted for your password in an inaccessible shell!!"
		ewarn "Please use 'eselect pinentry' to select either the gtk or qt front-end"
		;;
	esac
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		elog
		elog "Please restart thunderbird and/or seamonkey in order for them to use"
		elog "the newly installed version of enigmail."
	fi
}
