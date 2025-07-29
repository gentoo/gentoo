# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV='1.12.1.1550'

DESCRIPTION='Binary distribution of Clojure command-line tools'
HOMEPAGE='https://clojure.org'
SRC_URI="https://github.com/clojure/brew-install/releases/download/${MY_PV}/clojure-tools-${MY_PV}.tar.gz"
LICENSE='EPL-1.0'
SLOT='0'
KEYWORDS='~amd64'
IUSE=''

RDEPEND='>=virtual/jre-1.8:*'
DEPEND=''

S="${WORKDIR}/clojure-tools"

src_prepare() {
	default

	sed -i \
		-e "s@PREFIX@${EPREFIX}/usr/lib/clojure@g" \
		-e "s@BINDIR@${EPREFIX}/usr/bin@g" \
		clojure || die

	sed -i \
		-e "s@PREFIX@${EPREFIX}/usr/lib/clojure@g" \
		-e "s@BINDIR@${EPREFIX}/usr/bin@g" \
		clj || die
}

src_compile() {
	:
}

src_install() {
	local cljlibdir="/usr/lib/clojure/libexec"

	insinto /usr/lib/clojure
	doins deps.edn example-deps.edn tools.edn || die

	insinto "${cljlibdir}"
	doins exec.jar clojure-tools-${MY_PV}.jar || die

	dobin clojure || die
	dobin clj || die

	doman clojure.1 clj.1 || die
}
