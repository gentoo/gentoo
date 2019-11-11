# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic git-r3 systemd toolchain-funcs

DESCRIPTION="System performance tools for Linux"
HOMEPAGE="http://pagesperso-orange.fr/sebastien.godard/"
EGIT_REPO_URI="https://github.com/sysstat/sysstat"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug nls lm-sensors selinux static"

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
	selinux? ( sec-policy/selinux-sysstat )
"
PATCHES=(
	"${FILESDIR}"/${PN}-11.0.4-cron.patch
	"${FILESDIR}"/${PN}-11.7.3-flags.patch
)

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

	sa_lib_dir=/usr/lib/sa \
		conf_dir=/etc \
		econf \
			$(use_enable lm-sensors sensors) \
			$(use_enable nls) \
			$(usex debug --enable-debuginfo '') \
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
