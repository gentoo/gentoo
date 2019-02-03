# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PATCH_VERSION="5"

DESCRIPTION="Hibernate script supporting multiple suspend methods"
HOMEPAGE="https://gitlab.com/nigelcunningham/Hibernate-Script"
SRC_URI="http://tuxonice.nigelcunningham.com.au/downloads/all/${P}.tar.gz
	mirror://gentoo/${P}-patches-${PATCH_VERSION}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE="vim-syntax"

RDEPEND="!<media-gfx/splashutils-1.5.2"

DOCS=(
	CHANGELOG
	README
	SCRIPTLET-API
)

PATCHES=(
	"${WORKDIR}/${PV}"
)

src_install() {
	BASE_DIR="${D}" \
		DISTRIBUTION="gentoo" \
		PREFIX="/usr" \
		MAN_DIR="${D}/usr/share/man" \
		"${S}/install.sh" || die "Install failed"

	# hibernate-ram will default to using ram.conf
	dosym hibernate /usr/sbin/hibernate-ram

	newinitd init.d/hibernate-cleanup.sh hibernate-cleanup

	# other ebuilds can install scriplets to this dir
	keepdir /etc/hibernate/scriptlets.d/

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins hibernate.vim
	fi

	dodoc ${DOCS[@]}

	insinto /etc/logrotate.d
	newins "${S}"/logrotate.d-hibernate-script hibernate-script
	chmod 644 \
		"${D}/etc/hibernate/"*.conf \
		"${D}/etc/hibernate/blacklisted-modules" \
		"${D}/usr/share/hibernate/scriptlets.d/"* \
		"${D}/usr/share/hibernate/tuxonice-binary-signature.bin" \
		|| die
}

pkg_postinst() {
	elog
	elog "You should run the following command to invalidate suspend"
	elog "images on a clean boot."
	elog
	elog "  # rc-update add hibernate-cleanup boot"
	elog
	elog "See /usr/share/doc/${PF}/README.* for further details."
	elog
	elog "Please note that you will need to manually emerge any utilities"
	elog "(radeontool, vbetool, ...) enabled in the configuration files,"
	elog "should you wish to use them."
}
