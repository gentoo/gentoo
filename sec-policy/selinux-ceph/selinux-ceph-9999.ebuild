# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-ceph/selinux-ceph-9999.ebuild,v 1.1 2015/07/13 18:06:12 swift Exp $
EAPI="5"

IUSE=""
MODS="ceph"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for ceph"

if [[ $PV == 9999* ]] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
