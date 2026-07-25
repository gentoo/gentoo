# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit java-pkg-2

DESCRIPTION="Development tools for the Clojure programming language"
HOMEPAGE="https://clojure.org/
	https://github.com/clojure/brew-install/"

SRC_URI="https://github.com/clojure/brew-install/releases/download/${PV}/${P}.tar.gz
	-> ${P}.release.gh.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="EPL-1.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

RDEPEND="
	>=virtual/jre-1.8:*
	app-misc/rlwrap
"

src_install() {
	local app_lib="/usr/share/${PN}/lib"

	java-pkg_newjar "${P}.jar"

	mv exec.jar "${PN}-exec.jar" || die
	java-pkg_dojar "${PN}-exec.jar"

	insinto "${app_lib}"
	doins deps.edn example-deps.edn tools.edn

	sed -i clj clojure \
		-e "s|BINDIR|${EPREFIX}${app_lib}|" \
		-e "s|PREFIX|${EPREFIX}${app_lib}|" \
		-e "s|libexec/||g" \
		-e "s|${PN}-\$version.jar|${PN}.jar|g" \
		-e "s|exec.jar|${PN}-exec.jar|g" \
		|| die

	exeinto "${app_lib}"
	doexe clj clojure
	dosym -r "${app_lib}/clj" /usr/bin/clj

	doman clj.1
}

pkg_postinst() {
	einfo "Because Gentoo provides both dev-lang/clojure (the core language),"
	einfo "the language part is installed as \"clojure\" executable and"
	einfo "the development tools as the \"clj\" executable."

	einfo "If you plan to use CIDER (GNU Emacs package) you probably"
	einfo "need to customize the \"cider-clojure-cli-command\" variable and"
	einfo "set it to \"/usr/share/${PN}/lib/clojure\"."
}
