# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="sqlite"

inherit python-single-r1 qmake-utils

DESCRIPTION="GUI administration and development platform for PostgreSQL"
HOMEPAGE="https://www.pgadmin.org/"
SRC_URI="https://ftp.postgresql.org/pub/pgadmin/${PN}/v${PV}/source/${P}.tar.gz"

LICENSE="POSTGRESQL"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE="doc"

RESTRICT="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# libsodium dep added because of 689678
COMMON_DEPEND="${PYTHON_DEPS}
	dev-libs/libsodium[-minimal]
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtwidgets:5
"

DEPEND="${COMMON_DEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

RDEPEND="${COMMON_DEPEND}
	>=app-text/htmlmin-0.1.12[${PYTHON_USEDEP}]
	>=dev-python/blinker-1.4[${PYTHON_USEDEP}]
	>=dev-python/flask-1.0.2[${PYTHON_USEDEP}]
	>=dev-python/flask-gravatar-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/flask-htmlmin-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/flask-login-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/flask-mail-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/flask-migrate-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/flask-paranoid-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/flask-principal-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/flask-security-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/flask-sqlalchemy-2.3.2[${PYTHON_USEDEP}]
	>=dev-python/flask-wtf-0.14.2[${PYTHON_USEDEP}]
	>=dev-python/passlib-1.7.1[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.5.1[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2.8[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/python-sqlparse-0.2.4[${PYTHON_USEDEP}]
	>=dev-python/pytz-2018.9[${PYTHON_USEDEP}]
	>=dev-python/simplejson-3.16.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.12.0[${PYTHON_USEDEP}]
	>=dev-python/speaklater-1.3[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.2.18[${PYTHON_USEDEP}]
	>=dev-python/sshtunnel-0.1.4[${PYTHON_USEDEP}]
	>=dev-python/wtforms-2.2.1[${PYTHON_USEDEP}]
"

S="${WORKDIR}"/${P}/runtime

src_prepare() {
	cd "${WORKDIR}"/${P} || die
	default
}

src_configure() {
	eqmake5
}

src_compile() {
	default
	if use doc; then
		cd "${WORKDIR}"/${P} || die
		emake docs
	fi
}

src_install() {
	dobin pgAdmin4

	cd "${WORKDIR}"/${P} || die

	local APP_DIR=/usr/share/${PN}/web
	insinto "${APP_DIR}"
	doins -r web/*
	cat > "${D}${APP_DIR}"/config_local.py <<-EOF
		SERVER_MODE = False
		UPGRADE_CHECK_ENABLED = False
	EOF
	python_optimize "${D}${APP_DIR}"

	local CONFIG_DIR="/etc/xdg/pgadmin"
	dodir "${CONFIG_DIR}"
	cat > "${D}${CONFIG_DIR}"/pgadmin4.conf <<-EOF
		[General]
		ApplicationPath=${APP_DIR}
		PythonPath=$(python_get_sitedir)
	EOF

	if use doc; then
		rm -r docs/en_US/_build/html/_sources || die
		insinto /usr/share/${PN}/docs/en_US/_build
		doins -r docs/en_US/_build/html
	fi
}
