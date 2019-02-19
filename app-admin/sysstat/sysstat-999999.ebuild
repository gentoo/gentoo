# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils flag-o-matic git-r3 multilib systemd toolchain-funcs

DESCRIPTION="System performance tools for Linux"
HOMEPAGE="http://pagesperso-orange.fr/sebastien.godard/"
EGIT_REPO_URI="https://github.com/sysstat/sysstat"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug nls lm_sensors selinux static"

CDEPEND="
	nls? ( virtual/libintl )
	lm_sensors? ( sys-apps/lm_sensors:= )
"
DEPEND="
	${CDEPEND}
	nls? ( sys-devel/gettext )
"
RDEPEND="
	${CDEPEND}
	selinux? ( sec-policy/selinux-sysstat )
"
PATCHES=(
	"${FILESDIR}"/${PN}-11.0.4-cron.patch
	"${FILESDIR}"/${PN}-11.7.3-flags.patch
)

SYSSTAT_FAKE_RC_DIR=Gentoo-does-not-use-rc.d

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

	default
}

src_configure() {
	tc-export AR
	use static && append-ldflags -static

	sa_lib_dir=/usr/$(get_libdir)/sa \
		conf_dir=/etc \
		rcdir=${SYSSTAT_FAKE_RC_DIR} \
		econf \
			$(use_enable debug debuginfo) \
			$(use_enable lm_sensors sensors) \
			$(use_enable nls) \
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

	rm -r "${D}/${SYSSTAT_FAKE_RC_DIR}" || die
	newinitd "${FILESDIR}"/${PN}.init.d ${PN}
	systemd_dounit ${PN}.service

	rm -f "${D}"usr/share/doc/${PF}/COPYING
}
