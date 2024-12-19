data "aws_route53_zone" "domain" {
    name = "mydomain.com"
}

resource "aws_route53_record" "database_alias" {
    zone_id = data.aws_route53_zone.domain.zone_id
    name = "database-test.mydomain.com"
    type = "A"

    alias {
        name = var.db_dnsname
        zone_id = var.db_zoneid
        evaluate_target_health = true
    }
}

resource "aws_route53_zone" "privatedomain" {
    name = "mydomainc.com"

    vpc {
        vpc_id = var.vpc_id
    }
}

resource "aws_route53_record" "internal_database_alias" {
    zone_id = aws_route53_zone.privatedomain.zone_id
    name = "db.mydomainc.com"
    type = "A"

    alias {
        name = var.db_dnsname
        zone_id = var.db_zoneid
        evaluate_target_health = true
    }
}

output "route53zoneid" {
    value = aws_route53_zone.privatedomain.zone_id
}


