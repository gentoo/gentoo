# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit wrapper

DESCRIPTION="New dialect of Lisp, works well for web applications"
HOMEPAGE="http://www.arclanguage.org/"
SRC_URI="http://www.arclanguage.org/${PN}${PV}.tar -> ${P}.tar"
S="${WORKDIR}/${PN}${PV}"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	!app-arch/arc
	dev-scheme/racket:=
"
DEPEND="${RDEPEND}"

src_compile() {
	# byte-compile some racket modules
	local mod
	for mod in ac brackets ; do
		raco make --vv ./${mod}.scm || die "raco failed to compile ${mod}"
	done
}

src_install() {
	dodoc copyright how-to-run-news
	rm copyright how-to-run-news || die

	insinto /usr/share/${PN}
	doins -r *

	make_wrapper ${PN} "racket --load ./as.scm" /usr/share/${PN}
}
