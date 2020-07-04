# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="Cloud image storage services client (like Flickr or Picasa)"

SLOT="0"
KEYWORDS=""
IUSE="debug +deathnote +rappor +spegnersi +vangog"

DEPEND="
	~app-leechcraft/lc-core-${PV}
	dev-qt/qtdeclarative:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	rappor? ( dev-qt/qtxml:5 )
	deathnote? (
		dev-qt/qtxml:5
		dev-qt/qtxmlpatterns:5
	)
	spegnersi? (
		dev-libs/kqoauth
		dev-qt/qtxml:5
	)
	vangog? ( dev-qt/qtxml:5 )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_BLASQ_DEATHNOTE=$(usex deathnote)
		-DENABLE_BLASQ_RAPPOR=$(usex rappor)
		-DENABLE_BLASQ_SPEGNERSI=$(usex spegnersi)
		-DENABLE_BLASQ_VANGOG=$(usex vangog)
	)

	cmake_src_configure
}
