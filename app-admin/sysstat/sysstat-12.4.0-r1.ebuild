# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils flag-o-matic systemd toolchain-funcs

DESCRIPTION="System performance tools for Linux"
HOMEPAGE="http://pagesperso-orange.fr/sebastien.godard/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="dcron debug nls lm-sensors selinux static systemd"

CDEPEND="
	nls? ( virtual/libintl )
	lm-sensors? ( sys-apps/lm-sensors:= )
"
DEPEND="
	${CDEPEND}
	nls? ( sys-devel/gettext )
"
RDEPEND="
	${CDEPEND}
	!dcron? ( !sys-process/dcron )
	selinux? ( sec-policy/selinux-sysstat )
"
PATCHES=(
	"${FILESDIR}"/${PN}-11.7.3-flags.patch
)

REQUIRED_USE="dcron? ( !systemd )"

src_prepare() {
	if use nls; then
		strip-linguas -i nls/
		local lingua pofile
		for pofile in nls/*.po; do
			lingua=${pofile/nls\/}
			lingua=${lingua/.po}
			if ! has ${lingua} ${LINGUAS}; then
				rm "nls/${lingua}.po" || die
			fi
		done
	fi

	use dcron && { sed -i 's/@CRON_OWNER@ //g' cron/sysstat.crond.in || die ; }
	default
}

src_configure() {
	tc-export AR
	use static && append-ldflags -static

	# --enable-compress-manpg <= Yes, that is inverted.
	sa_lib_dir=/usr/lib/sa \
		conf_dir=/etc \
		econf \
			$(use_enable !systemd use-crond) \
			$(use_enable lm-sensors sensors) \
			$(use_enable nls) \
			$(usex debug --enable-debuginfo '') \
			--enable-compress-manpg \
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
