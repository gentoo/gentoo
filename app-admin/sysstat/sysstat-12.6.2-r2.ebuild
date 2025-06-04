# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs

DESCRIPTION="System performance tools for Linux"
HOMEPAGE="https://sysstat.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="dcron debug nls lm-sensors selinux systemd"
REQUIRED_USE="dcron? ( !systemd )"

DEPEND="
	nls? ( virtual/libintl )
	lm-sensors? ( sys-apps/lm-sensors:= )
"
RDEPEND="
	${DEPEND}
	!dcron? ( !sys-process/dcron )
	selinux? ( sec-policy/selinux-sysstat )
"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-12.6.2-check_overflow.patch
	"${FILESDIR}"/${PN}-12.6.2-defs_and_flags.patch
)

src_prepare() {
	if use dcron; then
		sed -i 's/@CRON_OWNER@ //g' cron/sysstat.crond.in || die
	fi
	default
}

src_configure() {
	tc-export AR

	# --enable-lto only appends -flto
	sa_lib_dir=/usr/lib/sa \
		conf_dir=/etc \
		econf \
			$(use_enable !systemd use-crond) \
			$(use_enable lm-sensors sensors) \
			$(use_enable nls) \
			$(usev debug --enable-debuginfo) \
			--disable-compress-manpg \
			--disable-stripping \
			--disable-pcp \
			--enable-copy-only \
			--enable-documentation \
			--enable-install-cron \
			--with-systemdsystemunitdir=$(systemd_get_systemunitdir)
}

src_install() {
	keepdir /var/log/sa

	emake \
		CHOWN=true \
		DESTDIR="${D}" \
		DOC_DIR=/usr/share/doc/${PF} \
		MANGRPARG='' \
		install

	dodoc -r contrib/

	newinitd "${FILESDIR}"/${PN}.init.d ${PN}
	systemd_dounit ${PN}.service

	rm "${D}"/usr/share/doc/${PF}/COPYING || die
}
