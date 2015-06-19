# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/obs-service-format_spec_file/obs-service-format_spec_file-20130618.ebuild,v 1.1 2013/11/02 09:16:48 scarabeus Exp $

EAPI=5

ADDITIONAL_FILES="
	licenses_changes.txt
	patch_license
	prepare_spec
"
inherit obs-service

IUSE=""
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="${DEPEND}
	dev-util/obs-service-source_validator
"
