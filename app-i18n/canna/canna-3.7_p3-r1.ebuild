# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cannadic toolchain-funcs

MY_P="Canna${PV//[._]/}"

DESCRIPTION="A client-server based Kana-Kanji conversion system"
HOMEPAGE="http://canna.osdn.jp/"
SRC_URI="mirror://sourceforge.jp/canna/9565/${MY_P}.tar.bz2"

LICENSE="MIT GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="x11-misc/gccmakedep
	x11-misc/imake"
RDEPEND=""
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-kpdef.patch
	"${FILESDIR}"/${PN}-overflow.patch
	"${FILESDIR}"/${PN}-posix-sort.patch
	"${FILESDIR}"/${PN}-Wformat.patch
	"${FILESDIR}"/${PN}-Wformat-security.patch
)
DOCS="*CHANGES* ChangeLog INSTALL* README* RKCCONF* WHATIS*"

src_prepare() {
	default

	find . -name '*.man' -o -name '*.jmn' | xargs sed -i.bak -e 's/1M/8/g' || die

	# Multilib-strict fix for amd64
	sed -i "/DefLibCannaDir/s:/lib$:/$(get_libdir):" Canna.conf
}

src_configure() {
	xmkmf -a || die
}

src_compile() {
	# bug #279706
	emake -j1 \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS}" \
		SHLIBGLOBALSFLAGS="${LDFLAGS}" \
		${PN}
}

src_install() {
	emake DESTDIR="${D}" install install.man
	einstalldocs

	dodir /usr/share/man{,/ja}/man8
	local man mandir
	for man in cannaserver cannakill ; do
		for mandir in "${D}"/usr/share/man "${D}"/usr/share/man/ja ; do
			mv ${mandir}/man1/${man}.1 ${mandir}/man8/${man}.8
		done
	done

	# for backward compatibility
	dosbin "${FILESDIR}"/update-canna-dics_dir

	keepdir /var/lib/${PN}/dic/{user,group}
	fowners bin:bin /var/lib/${PN}/dic/{user,group}
	fperms 0775 /var/lib/${PN}/dic/{user,group}

	insinto /var/lib/${PN}/dic/dics.d
	newins "${ED}"/var/lib/${PN}/dic/${PN}/dics.dir 00${PN}.dics.dir

	keepdir /var/log/${PN}

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}

	insinto /etc
	newins "${FILESDIR}"/${PN}.hosts hosts.${PN}
}

pkg_postinst() {
	update-cannadic-dir

	if ! locale -a | grep -iq "ja_JP.eucjp"; then
		elog "Some dictionary tools in this package require ja_JP.EUC-JP locale."
		elog
		elog "# echo 'ja_JP.EUC-JP EUC-JP' >> /etc/locale.gen"
		elog "# locale-gen"
		elog
	fi
}
