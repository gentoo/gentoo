# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix readme.gentoo-r1

DESCRIPTION="Scripts to support compressed swap devices or ramdisks with zRAM"
HOMEPAGE="https://github.com/vaeth/zram-init/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vaeth/${PN}.git"
else
	SRC_URI="https://github.com/vaeth/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv x86"
fi

LICENSE="GPL-2"
SLOT="0"
RESTRICT="binchecks strip test"

BDEPEND="sys-devel/gettext"

RDEPEND="
	>=app-shells/push-2.0
	virtual/libintl
	|| ( sys-apps/openrc sys-apps/openrc-navi sys-apps/systemd )
"

DISABLE_AUTOFORMATTING=true
DOC_CONTENTS="\
To use zram-init, activate it in your kernel and add it to the default
runlevel:
	rc-update add zram-init default
If you use systemd enable zram_swap, zram_tmp, and/or zram_var_tmp with
systemctl. You might need to modify the following file depending on the number
of devices that you want to create:
	/etc/modprobe.d/zram.conf.
If you use the \$TMPDIR as zram device with OpenRC, you should add zram-init to
the boot runlevel:
	rc-update add zram-init boot
Still for the same case, you should add in the OpenRC configuration file for
the services using \$TMPDIR the following line:
	rc_need=\"zram-init\""

src_prepare() {
	default

	hprefixify "${S}/man/${PN}.8"

	hprefixify -e "s%(}|:)(/(usr/)?sbin)%\1${EPREFIX}\2%g" \
		"${S}/sbin/${PN}.in"

	hprefixify -e "s%( |=)(/tmp)%\1${EPREFIX}\2%g" \
		"${S}/systemd/system"/* \
		"${S}/openrc"/*/*
}

src_compile() {
	emake PREFIX="${EPREFIX}/usr" MODIFY_SHEBANG=FALSE
}

src_install() {
	einstalldocs
	readme.gentoo_create_doc

	emake DESTDIR="${ED}" PREFIX="/usr" BINDIR="${ED}/sbin" SYSCONFDIR="/etc" \
		SYSTEMDDIR="${ED}/lib/systemd/system" install
}

pkg_postinst() {
	readme.gentoo_print_elog
}
