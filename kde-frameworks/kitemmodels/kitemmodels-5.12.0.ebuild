# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/kitemmodels/kitemmodels-5.12.0.ebuild,v 1.1 2015/07/16 20:33:15 johu Exp $

EAPI=5

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework providing data models that help with tasks such as sorting and filtering"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="test? ( dev-qt/qtwidgets:5 )"
