# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/xemacs-packages.eclass,v 1.19 2011/12/27 17:55:13 fauli Exp $

# @ECLASS: xemacs-packages.eclass
# @MAINTAINER:
# xemacs@gentoo.org
# @BLURB: Eclass to support elisp packages distributed by XEmacs.
# @DESCRIPTION:
# This eclass supports ebuilds for packages distributed by XEmacs.

EXPORT_FUNCTIONS src_unpack src_compile src_install

RDEPEND="${RDEPEND} app-editors/xemacs"
DEPEND="${DEPEND}"

[ -z "$HOMEPAGE" ]    && HOMEPAGE="http://xemacs.org/"
[ -z "$LICENSE" ]     && LICENSE="GPL-2"

# @ECLASS-VARIABLE: PKG_CAT
# @REQUIRED
# @DESCRIPTION:
# The package category that the package is in. Can be either standard,
# mule, or contrib.

case "${PKG_CAT}" in
	"standard" )
		MY_INSTALL_DIR="/usr/lib/xemacs/xemacs-packages" ;;

	"mule" )
		MY_INSTALL_DIR="/usr/lib/xemacs/mule-packages" ;;

	"contrib" )
		MY_INSTALL_DIR="/usr/lib/xemacs/site-packages" ;;
	*)
		die "Unsupported package category in PKG_CAT (or unset)" ;;
esac
[ -n "$DEBUG" ] && einfo "MY_INSTALL_DIR is ${MY_INSTALL_DIR}"

# @ECLASS-VARIABLE: EXPERIMENTAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set then the package is downloaded from the experimental packages
# repository, which is the staging area for packages upstream. Packages
# in the experimental repository are auto-generated from XEmacs VCS, so
# they may not be well-tested.

if [ -n "$EXPERIMENTAL" ]
then
	[ -z "$SRC_URI" ] && SRC_URI="http://ftp.xemacs.org/pub/xemacs/beta/experimental/packages/${P}-pkg.tar.gz"
else
	[ -z "$SRC_URI" ] && SRC_URI="http://ftp.xemacs.org/pub/xemacs/packages/${P}-pkg.tar.gz"
fi
[ -n "$DEBUG" ] && einfo "SRC_URI is ${SRC_URI}"

xemacs-packages_src_unpack() {
	return 0
}

xemacs-packages_src_compile() {
	einfo "Nothing to compile"
}

xemacs-packages_src_install() {
	dodir ${MY_INSTALL_DIR}
	cd "${D}${MY_INSTALL_DIR}"
	unpack ${A}
}
