# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools flag-o-matic toolchain-funcs

MY_P="${P/_beta/beta}"

DESCRIPTION="Emacs like micro editor Ng -- based on mg2a"
HOMEPAGE="http://tt.sakura.ne.jp/~amura/ng/"
SRC_URI="http://tt.sakura.ne.jp/~amura/archives/${PN}/${MY_P}.tar.gz"

LICENSE="Emacs"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${MY_P}-ncurses.patch
	"${FILESDIR}"/${MY_P}-configure.patch
)

src_prepare() {
	default

	sed -i "/NO_BACKUP/s/undef/define/" config.h
	cd sys/unix || die
	mv configure.{in,ac} || die
	eautoconf
	cd - >/dev/null || die
	cp sys/unix/configure . || die
	# written in K&R C
	append-flags \
		-Wno-implicit-function-declaration \
		-Wno-implicit-int \
		-Wno-return-type
}

src_configure() {
	econf --disable-canna
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	dodoc docs/* MANIFEST dot.${PN}

	insinto /usr/share/${PN}
	doins bin/*

	insinto /etc/skel
	newins {dot,}.${PN}
}

pkg_postinst() {
	elog
	elog "If you want to use user Config"
	elog "cp /etc/skel/.${PN} ~/.${PN}"
	elog "and edit your .${PN} configuration file."
	elog
}
