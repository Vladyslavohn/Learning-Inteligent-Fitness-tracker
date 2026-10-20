<div align="center">

# LIFT

**Local Instructors & Fitness Trainers**

Find a personal trainer who fits you, book a session and track your progress, all in one app.

![Status](https://img.shields.io/badge/status-in%20development-orange)
![Platform](https://img.shields.io/badge/platform-Android%208%2B-3DDC84?logo=android&logoColor=white)
![Kotlin](https://img.shields.io/badge/Kotlin%20Multiplatform-7F52FF?logo=kotlin&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot%204.1-6DB33F?logo=springboot&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL%2018-4169E1?logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)

</div>

---

> [!NOTE]
> LIFT is in early development. This README describes the planned scope of the first version.

## Table of contents

- [About](#about)
- [Features](#features)
- [How it works](#how-it-works)
- [Architecture](#architecture)
- [Tech stack](#tech-stack)
- [Matching & AI](#matching--ai)
- [Privacy & security](#privacy--security)
- [Team](#team)

## About

Today people pick a personal trainer by price or by Instagram. Trainers run their business through chats and spreadsheets, and gyms lose new members who never got proper guidance.

LIFT brings **clients, trainers and gyms** together in one app:

- It **matches** a client with a trainer by goals, health limits, schedule, budget and location.
- It handles **booking and payments** in the app.
- It helps trainers **track client progress** with AI-drafted tips. The trainer approves every tip.

## Features

### For clients
- A short profile covering goals, health limits, free time, budget and location
- A ranked list of trainers who fit you, with the reason each one was shown
- Bookings at partner gyms or online, paid in the app
- Workout history and a progress overview
- Reviews, which you can leave only after a booked session

### For trainers
- Profile, calendar, payments and client notes in one place
- AI-drafted progress tips that the trainer approves or rejects
- Workout logging that works offline in the gym and syncs once the connection is back
- Payouts and identity verification through Stripe

### For gyms
- A listing on the map
- Partnerships with trainers

## How it works

```
 ┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
 │ 1. Profile   │ ─▶ │ 2. Match     │ ─▶ │ 3. Book      │ ─▶ │ 4. Progress  │
 │ goals, limits│    │ ranked,      │    │ gym / online │    │ trainer logs,│
 │ time, budget │    │ explained    │    │ in-app pay   │    │ AI drafts tip│
 └──────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
```

## Architecture

```
┌───────────────────────┐            ┌─────────────── Hetzner · Germany · Docker Compose ───────────────┐
│     Android app       │            │                                                                  │
│ Kotlin · Compose      │   HTTPS    │  ┌─────────┐  REST  ┌──────────────────┐  SQL  ┌──────────────┐  │
│ KMP shared core       │◀──────────▶│  │  Nginx  │──────▶ │ Spring Boot 4.1  │──────▶│ PostgreSQL 18│  │
│ offline sync          │            │  └─────────┘        │ modular monolith │       │ + job queue  │  │
└───────────▲───────────┘            │                     └──────────────────┘       └──────▲───────┘  │
            │                        │                                                       │          │
            │ push                   │                         ┌───────────────────────┐     │          │
   Firebase Cloud Messaging          │                         │ AI worker · Gemma 4   │─────┘          │
   Stripe Connect                    │                         └───────────────────────┘                │
                                     └──────────────────────────────────────────────────────────────────┘
```

## Tech stack

| Layer | Technologies |
|---|---|
| **Mobile** | Kotlin, Jetpack Compose, Kotlin Multiplatform (Ktor Client, Room, Koin), WorkManager |
| **Backend** | Kotlin 2.3, Spring Boot 4.1, Spring Modulith, Spring Security (JWT), Flyway |
| **API** | REST, OpenAPI |
| **Database** | PostgreSQL 18, PostGIS, pgvector |
| **AI** | Gemma 4 E4B (self-hosted, llama.cpp), Spring AI |
| **Payments** | Stripe Connect |
| **Notifications** | Firebase Cloud Messaging |
| **Infrastructure** | Docker Compose, Nginx, Let's Encrypt, Hetzner (EU) |
| **CI & testing** | GitHub Actions, Testcontainers, k6 |
| **Monitoring** | Spring Actuator, Micrometer, Prometheus, Grafana |

## Matching & AI

**Matching** uses a transparent formula, not an LLM:

1. **Filter.** SQL filters keep trainers who match the distance, budget, schedule and the qualifications the client's health limits require.
2. **Rank.** A weighted score ranks the remaining trainers:

```
score = 0.35·goal + 0.25·schedule + 0.15·distance + 0.15·budget + 0.10·quality
```

Every recommendation can be explained, for example "rehab experience, 3 evening slots, 2.1 km". After the pilot, the weights will be tuned on real data.

**The LLM (Gemma 4)** runs on our own server and handles two tasks in the background:

- It turns free text in Slovak into structured profile fields.
- It drafts progress tips from the workout log. The trainer approves or rejects each tip, and the AI never gives medical advice.

## Privacy & security

- **EU only.** All data, including health data, stays on our own servers in Germany.
- **No third parties.** Health data is never sent to a third-party AI or analytics provider.
- **Encryption.** Health data fields are encrypted, and so are the disks and backups.
- **Access log.** Every time a trainer opens a client's health data, we record it.
- **User control.** Users give explicit consent (GDPR Art. 9) and can delete their account and data at any time.

## Team

| Name | Role |
|---|---|
| **Ivan Pankevych** | Project Manager |
| **Vladyslav Ohnivko** | Backend & DevOps |
| **Bohdan Oliinyk** | Frontend & Mobile |
| **Daniil Paramonenko** | Research Lead |
| **Bohodar Pereviznyk** | Machine Learning |

---

<div align="center">
<sub>Built at FIIT STU Bratislava · 2026</sub>
</div>
