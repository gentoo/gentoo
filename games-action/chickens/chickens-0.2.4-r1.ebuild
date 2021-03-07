# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop

MY_P="ChickensForLinux-Linux-${PV}"
DESCRIPTION="Target chickens with rockets and shotguns. Funny"
HOMEPAGE="http://www.chickensforlinux.com/"
SRC_URI="http://www.chickensforlinux.com/${MY_P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror bindist"

DEPEND="acct-group/gamestat
	<media-libs/allegro-5"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	default

	sed -i \
		-e "s:HighScores:/var/games//${PN}/HighScores:" \
		-e "s:....\(.\)\(_\)\(.*.4x0\)\(.\):M\4\2\x42\x6Fn\1s\2:" \
		highscore.cpp HighScores || die
	sed -i \
		-e "s:options.cfg:/etc/${PN}/options.cfg:" \
		-e "s:\"sound/:\"/usr/share/${PN}/sound/:" \
		-e "s:\"dat/:\"/usr/share/${PN}/dat/:" \
		main.cpp README || die
	sed -i \
		-e '/^CPPFLAGS/d' \
		-e 's:g++:\\$(CXX) \\$(CXXFLAGS) \\$(LDFLAGS):' \
		configure || die
}

src_configure() {
	# econf (sometimes) fails, see https://bugs.gentoo.org/588544
	bash ./configure || die
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r dat sound
	dodoc AUTHOR README
	insinto /var/games/${PN}
	doins HighScores
	insinto /etc/${PN}
	doins options.cfg
	make_desktop_entry ${PN} Chickens

	fowners root:gamestat /usr/bin/${PN} /var/games/${PN}/HighScores
	fperms 2755 /usr/bin/${PN}
	fperms 660  /var/games/${PN}/HighScores
}
