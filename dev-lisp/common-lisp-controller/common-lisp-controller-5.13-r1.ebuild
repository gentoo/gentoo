# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/common-lisp-controller/common-lisp-controller-5.13-r1.ebuild,v 1.13 2015/05/30 06:40:48 jmorgan Exp $

EAPI="3"
inherit eutils

DESCRIPTION="Common Lisp Controller"
HOMEPAGE="http://packages.debian.org/unstable/devel/common-lisp-controller"
SRC_URI="mirror://gentoo/common-lisp-controller_${PV}.tar.gz"

LICENSE="LLGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

DEPEND="|| ( >=sys-apps/coreutils-8.15 app-misc/realpath )
	>=dev-lisp/asdf-1.84
	dev-lang/perl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}/man"
	ln -s clc-{,un}register-user-package.1
	for i in unregister-common-lisp-implementation {,un}register-common-lisp-source; do
		ln -s register-common-lisp-implementation.8 ${i}.8
	done
}

src_install() {
	dobin clc-register-user-package
	dobin clc-unregister-user-package
	dosbin register-common-lisp-implementation
	dosbin register-common-lisp-source
	dosbin unregister-common-lisp-implementation
	dosbin unregister-common-lisp-source

	dosbin clc-update-customized-images
	keepdir /etc/common-lisp/images

	insinto /usr/share/common-lisp/source/common-lisp-controller
	doins common-lisp-controller.lisp post-sysdef-install.lisp
	doman man/*.[138]
	insinto /etc
	doins "${FILESDIR}/${PV}/lisp-config.lisp"
	dodoc "${FILESDIR}/README.Gentoo"
	dodoc DESIGN.txt debian/changelog
}

pkg_postinst() {
	test -d /var/cache/common-lisp-controller \
		|| mkdir /var/cache/common-lisp-controller
	chmod 1777 /var/cache/common-lisp-controller

	# This code from ${S}/debian/postinst

	for compiler in /usr/lib/common-lisp/bin/*.sh
	do
		if [ -f "${compiler}" -a -r "${compiler}" -a -x "${compiler}" ] ; then
			i=${compiler##*/}
			i=${i%.sh}
			einfo ">>> Recompiling Common Lisp Controller for $i"
			bash "$compiler" install-clc || true
			einfo ">>> Done rebuilding"
		fi
	done

	# This code from ${S}/debian/preinst

	# cleanup fasl files:
	( find /usr/share/common-lisp/source/defsystem \
		/usr/share/common-lisp/source/asdf \
		/usr/share/common-lisp/source/common-lisp-controller -type f -not -name "*.lisp" -print0 \
		| xargs --null rm --force 2> /dev/null ) &>/dev/null

	# remove old autobuild files:
#	find /etc/common-lisp -name autobuild -print0 \
#		| xargs -0 rm 2> /dev/null || true
#	find /etc/common-lisp -type d -depth -print0 \
#		| xargs rmdir 2> /dev/null || true

	# remove old fals files:
	test -d /usr/lib/common-lisp-controller \
		&& rmdir --ignore-fail-on-non-empty /usr/lib/common-lisp-controller
	for compiler in /usr/lib/common-lisp/bin/*.sh ; do
		if [ -f "$compiler" -a -r "$compiler" ] ; then
			i=${compiler##*/}
			i=${i%.sh}
			if [ -d "/usr/lib/common-lisp/${i}" ] ; then
				rm -rf "/usr/lib/common-lisp/${i}"
			fi
		fi
	done
}
