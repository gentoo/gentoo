EAPI=8

inherit autotools

DESCRIPTION="Official ODBC driver for PostgreSQL"
HOMEPAGE="https://odbc.postgresql.org/"

SRC_URI="https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-${PV//\./_}.tar.gz"
S="${WORKDIR}/${PN}-REL-${PV//\./_}"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="iodbc ssl threads"

DEPEND="dev-db/postgresql:*[ssl?]
		!iodbc? ( dev-db/unixODBC )
		iodbc? ( dev-db/libiodbc )
"
RDEPEND="${DEPEND}"

# Tests require installation and a server setup for the purpose.
RESTRICT="test"

DOCS=( readme.txt )
HTML_DOCS=(
	docs/config.html
	docs/config-opt.html
	docs/editConfiguration.jpg
	docs/release-7.3.html
	docs/release.html
)

src_configure()
{
	eautoreconf --force --install

	econf \
		$(use_with iodbc) \
		$(use_with !iodbc unixodbc) \
		$(use_enable threads pthreads)
}

src_install()
{
	default_src_install
	find ${D} -name "*.la" -exec rm -f {} \;
}
