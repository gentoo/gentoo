# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A multi-user dungeon game system server"
HOMEPAGE="https://www.circlemud.org/"
SRC_URI="https://www.circlemud.org/pub/CircleMUD/3.x/circle-${PV}.tar.bz2"
S="${WORKDIR}"/circle-${PV}

LICENSE="circlemud"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/openssl:0="
RDEPEND="
	${DEPEND}
	acct-group/gamestat
"

src_prepare() {
	default

	cd src || die

	touch .accepted || die

	sed -i \
		-e 's:^read.*::' licheck || die

	# Now let's rename binaries (too many are very generic)
	sed -i \
		-e "s:\.\./bin/autowiz:${PN}-autowiz:" limits.c || die

	tc-export CC
	eapply "${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	emake -C src
}

src_install() {
	local bin

	for bin in autowiz delobjs listrent mudpasswd play2to3 purgeplay \
	           shopconv showplay sign split wld2html ; do
		newbin bin/${bin} ${PN}-${bin}
	done

	dobin bin/circle

	insinto /var/lib/${PN}
	doins -r lib/*

	insinto /etc/${PN}
	doins lib/etc/*

	dodoc doc/{README.UNIX,*.pdf,*.txt} ChangeLog FAQ README release_notes.${PV}.txt
}
