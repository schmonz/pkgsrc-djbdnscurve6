# $NetBSD: Makefile,v 1.27 2024/04/03 03:30:45 schmonz Exp $

DISTNAME=		djbdnscurve6-44d
CATEGORIES=		net
MASTER_SITES=		https://www.fehcom.de/ipnet/djbdnscurve6/
EXTRACT_SUFX=		.tgz

MAINTAINER=		schmonz@NetBSD.org
HOMEPAGE=		https://www.fehcom.de/ipnet/djbdnscurve6.html
COMMENT=		Fork of djbdns with IPv6 and DNSCurve support
LICENSE=		public-domain

CONFLICTS+=		djbdns-[0-9]*

WRKSRC=			${WRKDIR}/net/${PKGBASE}/${DISTNAME}
DJB_SLASHPACKAGE=	yes

DJB_CONFIG_DIR=		${WRKSRC}

SUBST_CLASSES+=		etc
SUBST_STAGE.etc=	do-configure
SUBST_FILES.etc=	src/dns_rcrw.c man/qualification.5
SUBST_SED.etc=		-e 's|/etc/dnsrewrite|${PKG_SYSCONFBASE}/dnsrewrite|g'
SUBST_MESSAGE.etc=	Fixing prefix.

SUBST_CLASSES+=			sysconfdir
SUBST_STAGE.sysconfdir=		do-configure
SUBST_FILES.sysconfdir=		src/dnscache-conf.c
SUBST_VARS.sysconfdir=		PKG_SYSCONFDIR
SUBST_MESSAGE.sysconfdir=	Fixing sysconfdir.

EGDIR=			${PREFIX}/share/examples/${PKGBASE}
CONF_FILES+=		${EGDIR}/dnsroots.global ${PKG_SYSCONFDIR}/dnsroots.global
BUILD_DEFS+=		PKG_SYSCONFBASE

CPPFLAGS+=		-Iinclude

INSTALLATION_DIRS=	${PKGMANDIR}/man1 ${PKGMANDIR}/man5 ${PKGMANDIR}/man8 \
			share/examples/${PKGBASE}

do-install:
	cd ${WRKSRC}/compile && ./install && ./instcheck
	cd ${WRKSRC}/man; for i in 1 5 8; do				\
		for j in *.$$i; do ${INSTALL_MAN} $$j			\
			${DESTDIR}${PREFIX}/${PKGMANDIR}/man$$i; done	\
	done

BUILDLINK_API_DEPENDS.fehqlibs+=	fehqlibs>=23
.include "../../net/fehqlibs/buildlink3.mk"
.include "../../security/libsodium/buildlink3.mk"
.include "../../mk/djbware.mk"
.include "../../mk/bsd.pkg.mk"
