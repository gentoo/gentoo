# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 systemd

MY_P="${P/pyicq-t/pyicqt}"

DESCRIPTION="Python based jabber transport for ICQ"
HOMEPAGE="https://code.google.com/p/pyicqt/"
SRC_URI="https://pyicqt.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="webinterface"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	net-im/jabber-base"
RDEPEND="${DEPEND}
	|| (
		(
			dev-python/twisted-core[${PYTHON_USEDEP}]
			dev-python/twisted-words[${PYTHON_USEDEP}]
			dev-python/twisted-web[${PYTHON_USEDEP}]
		)
		dev-python/twisted[${PYTHON_USEDEP}]
	)
	webinterface? ( >=dev-python/nevow-0.4.1[${PYTHON_USEDEP}] )
	dev-python/pillow[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"
PATCHES=(
	"${FILESDIR}/${P}-python26-warnings.diff"
	"${FILESDIR}/${P}-pillow-imaging.patch"
)

src_install() {
	python_moduleinto ${PN}
	cp PyICQt.py ${PN}.py || die
	python_domodule ${PN}.py data tools src

	insinto /etc/jabber
	newins config_example.xml ${PN}.xml
	fperms 600 /etc/jabber/${PN}.xml
	fowners jabber:jabber /etc/jabber/${PN}.xml
	fperms 755 "$(python_get_sitedir)/${PN}/${PN}.py"
	sed -i \
		-e "s:<spooldir>[^\<]*</spooldir>:<spooldir>/var/spool/jabber</spooldir>:" \
		-e "s:<pid>[^\<]*</pid>:<pid>/var/run/jabber/${PN}.pid</pid>:" \
		"${ED}/etc/jabber/${PN}.xml" || die

	newinitd "${FILESDIR}/${PN}-0.8-initd-r1" ${PN}
	systemd_dounit "${FILESDIR}/${PN}.service"
	sed -i -e "s:INSPATH:$(python_get_sitedir)/${PN}:" \
		"${ED}/etc/init.d/${PN}" "${ED}/usr/lib/systemd/system/${PN}.service" || die

	python_fix_shebang "${D}$(python_get_sitedir)/${PN}"
}
