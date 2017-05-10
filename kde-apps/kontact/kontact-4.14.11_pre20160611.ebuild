# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="Container application to unify several major PIM applications within one"
HOMEPAGE="https://www.kde.org/applications/office/kontact/"

KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepim-common-libs '' 4.14.11_pre20160611)
	$(add_kdeapps_dep kdepimlibs '' 4.14.11_pre20160611)
"
RDEPEND="${DEPEND}"

KMLOADLIBS="kdepim-common-libs"
KMSAVELIBS="true"

# We remove plugins that are related to external kdepim programs. This way
# kontact doesn't have to depend on all programs it has plugins for.
# kcontactmanager gone from kdesvn
#
KMEXTRACTONLY="
	kontact/plugins/akregator/
	kontact/plugins/kaddressbook/
	kontact/plugins/kjots/
	kontact/plugins/kmail/
	kontact/plugins/knode/
	kontact/plugins/knotes/
	kontact/plugins/korganizer/
	kontact/plugins/ktimetracker/
	kontact/plugins/planner/
	kontact/plugins/specialdates/
	libkdepimdbusinterfaces/
"

src_unpack() {
	if use handbook; then
		KMEXTRA+="
			doc/kontact-admin/
		"
	fi

	kde4-meta_src_unpack
}
