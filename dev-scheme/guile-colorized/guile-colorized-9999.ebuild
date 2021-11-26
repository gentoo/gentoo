# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Colorized REPL for GNU Guile"
HOMEPAGE="https://gitlab.com/NalaGinrut/guile-colorized/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/NalaGinrut/${PN}.git"
else
	# Latest release (before this commit from 2019) was in 2015
	COMMIT_SHA="1625a79f0e31849ebd537e2a58793fb45678c58f"
	SRC_URI="https://gitlab.com/NalaGinrut/${PN}/-/archive/${COMMIT_SHA}.tar.bz2 -> ${P}.tar.bz2"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${COMMIT_SHA}"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND=">=dev-scheme/guile-2.0.9:="
DEPEND="${DEPEND}"

src_prepare() {
	default

	# http://debbugs.gnu.org/cgi/bugreport.cgi?bug=38112
	find "${S}" -name "*.scm" -exec touch {} + || die
}

src_install() {
	einstalldocs

	local loadpath=$(guile -c '(display (string-append (car %load-path) "/ice-9"))')
	mkdir -p "${D}${loadpath}"
	emake TARGET="${D}${loadpath}" install
}
