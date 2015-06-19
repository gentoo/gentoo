# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-uwsgi/selinux-uwsgi-9999.ebuild,v 1.1 2015/04/11 11:54:08 perfinion Exp $
EAPI="5"

IUSE=""
MODS="uwsgi"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for uWSGI"

if [[ $PV == 9999* ]] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
