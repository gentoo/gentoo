# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 systemd tmpfiles toolchain-funcs

DESCRIPTION="Policy routing daemon with failover and load-balancing"
HOMEPAGE="https://github.com/ncopa/pingu"
SRC_URI=""
EGIT_REPO_URI="https://github.com/ncopa/${PN}.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="debug doc"

RDEPEND="dev-libs/libev:="
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	virtual/pkgconfig
	doc? ( app-text/asciidoc )"

# Fix QA with install into path /run/pingu must be created at runtime
PATCHES=( "${FILESDIR}"/"${PN}"-1.5-makefile.patch )

src_configure() {
	./configure "$(use_enable debug)" "$(use_enable doc)" \
		--prefix=/usr || die "configure failed"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default

	newtmpfiles "${FILESDIR}"/pingu.tmpfile pingu.conf
	newinitd "${FILESDIR}"/pingu.initd pingu
	newconfd "${FILESDIR}"/pingu.confd pingu
	systemd_dounit "${FILESDIR}"/pingu.service
	keepdir /var/lib/pingu
	insinto /etc/pingu
	newins pingu.conf pingu.conf.example
}

pkg_postinst() {
	tmpfiles_process pingu.conf
}
