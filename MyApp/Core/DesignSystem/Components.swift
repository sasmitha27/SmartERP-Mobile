import SwiftUI

struct FieldLabel: View {
    let value: String

    init(_ value: String) {
        self.value = value
    }

    var body: some View {
        Text(value).font(.caption.bold()).foregroundStyle(ERPTheme.muted)
    }
}

struct SectionTitle: View {
    let value: String

    init(_ value: String) {
        self.value = value
    }

    var body: some View {
        Text(value.uppercased())
            .font(.caption.bold())
            .foregroundStyle(ERPTheme.muted)
            .padding(.top, 4)
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.caption).foregroundStyle(ERPTheme.muted)
            Text(value).font(.system(size: 32, weight: .bold)).foregroundStyle(ERPTheme.ink)
            Spacer()
            Circle().fill(color).frame(width: 8, height: 8)
        }
        .padding(14)
        .frame(height: 108)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ERPTheme.secondaryBackground, in: .rect(cornerRadius: 16))
    }
}

struct ActionCard: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon).foregroundStyle(ERPTheme.blue)
            Text(title).font(.subheadline.weight(.semibold)).foregroundStyle(ERPTheme.ink)
            Text(subtitle).font(.caption).foregroundStyle(ERPTheme.muted)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
        .background(ERPTheme.secondaryBackground, in: .rect(cornerRadius: 16))
    }
}

struct ActivityCard: View {
    let title: String
    let subtitle: String
    let badge: String
    let color: Color

    var body: some View {
        HStack {
            Rectangle().fill(color).frame(width: 5)
            VStack(alignment: .leading, spacing: 5) {
                Text(title).font(.subheadline.weight(.semibold))
                Text(subtitle).font(.caption).foregroundStyle(ERPTheme.muted)
            }
            Spacer()
            StatusPill(badge, color: color)
        }
        .padding(.vertical, 12)
        .padding(.trailing, 12)
        .background(ERPTheme.secondaryBackground, in: .rect(cornerRadius: 14))
    }
}

struct StatusPill: View {
    let value: String
    let color: Color

    init(_ value: String, color: Color) {
        self.value = value
        self.color = color
    }

    var body: some View {
        Text(value)
            .font(.caption.weight(.semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(color.opacity(0.13), in: .capsule)
    }
}

struct ProductRow: View {
    let name: String
    let detail: String
    let quantity: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(name).font(.subheadline.weight(.semibold))
                Text(detail).font(.caption).foregroundStyle(ERPTheme.muted)
            }
            Spacer()
            Text(quantity).font(.headline).foregroundStyle(ERPTheme.navy)
        }
        .padding()
        .background(ERPTheme.secondaryBackground, in: .rect(cornerRadius: 14))
    }
}

struct SummaryStat: View {
    let label: String
    let value: String

    init(_ label: String, _ value: String) {
        self.label = label
        self.value = value
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(label).font(.caption).foregroundStyle(ERPTheme.muted)
            Text(value).font(.title2.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                ERPTheme.blue.opacity(configuration.isPressed ? 0.75 : 1),
                in: .rect(cornerRadius: 14)
            )
    }
}
